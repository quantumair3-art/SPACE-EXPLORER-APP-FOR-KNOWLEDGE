#include "VoyagerManager.h"

#include <QDateTime>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrlQuery>
#include <QDebug>
#include <QRegularExpression>
#include <QStringList>
#include <cmath>

namespace {

const double AU_KM = 149597870.7;

bool numberFromField(const QString &field, double &value)
{
    const QString s = field.trimmed();

    if (s.isEmpty() ||
        s == "n.a." ||
        s == "N/A" ||
        s == "--")
    {
        return false;
    }

    bool ok = false;
    value = s.toDouble(&ok);
    return ok && std::isfinite(value);
}

QString firstDataLine(const QString &result)
{
    const int soe = result.indexOf("$$SOE");
    const int eoe = result.indexOf("$$EOE");

    if (soe < 0 || eoe < 0 || eoe <= soe)
        return QString();

    const QString table = result.mid(soe + 5, eoe - (soe + 5)).trimmed();

    const QStringList lines = table.split(
        QRegularExpression("\\r?\\n"),
        Qt::SkipEmptyParts
        );

    if (lines.isEmpty())
        return QString();

    return lines.first().trimmed();
}

}

VoyagerManager::VoyagerManager(QObject *parent)
    : QObject(parent)
{
}

void VoyagerManager::updateVoyager1()
{
    if (pendingRequests > 0)
    {
        qDebug() << "Voyager update already running";
        return;
    }

    pendingRequests = 2;

    const QDateTime now = QDateTime::currentDateTimeUtc();

    // Request the same exact UTC instant for both queries.
    // TLIST avoids the START_TIME/STOP_TIME time-scale problem.
    fetchEarthData(now, now);
    fetchSunData(now, now);
}

QUrl VoyagerManager::makeHorizonsUrl(
    const QString &center,
    const QDateTime &start,
    const QDateTime &stop,
    const QString &quantities
    ) const
{
    Q_UNUSED(stop);

    QUrl url("https://ssd.jpl.nasa.gov/api/horizons.api");
    QUrlQuery query;

    query.addQueryItem("format", "json");
    query.addQueryItem("COMMAND", "'-31'");
    query.addQueryItem("OBJ_DATA", "'NO'");
    query.addQueryItem("MAKE_EPHEM", "'YES'");
    query.addQueryItem("EPHEM_TYPE", "'OBSERVER'");
    query.addQueryItem("CENTER", "'" + center + "'");

    const QString timeText = start.toUTC().toString("yyyy-MM-dd HH:mm:ss");

    query.addQueryItem("TLIST", "'" + timeText + "'");
    query.addQueryItem("TLIST_TYPE", "'CAL'");
    query.addQueryItem("TIME_TYPE", "'UT'");
    query.addQueryItem("QUANTITIES", "'" + quantities + "'");
    query.addQueryItem("RANGE_UNITS", "'KM'");
    query.addQueryItem("CSV_FORMAT", "'YES'");
    query.addQueryItem("TIME_DIGITS", "'SECONDS'");

    url.setQuery(query);

    qDebug() << "JPL Horizons URL:" << url.toString();

    return url;
}

void VoyagerManager::fetchEarthData(
    const QDateTime &start,
    const QDateTime &stop
    )
{
    // 20 = observer range/range-rate
    // 21 = one-way light time
    // 22 = target speed relative to Sun and observer
    const QUrl url = makeHorizonsUrl(
        "500@399",
        start,
        stop,
        "20,21,22"
        );

    QNetworkRequest request(url);
    request.setHeader(
        QNetworkRequest::UserAgentHeader,
        "Quantum Space Explorer/1.0"
        );
    request.setTransferTimeout(20000);
    request.setAttribute(
        QNetworkRequest::Http2AllowedAttribute,
        false
        );

    QNetworkReply *reply = manager.get(request);

    connect(
        reply,
        &QNetworkReply::finished,
        this,
        [this, reply]() {
            handleReply(reply, true);
        }
        );
}

void VoyagerManager::fetchSunData(
    const QDateTime &start,
    const QDateTime &stop
    )
{
    // 19 = heliocentric range/range-rate
    // 22 = target speed relative to Sun and observer
    const QUrl url = makeHorizonsUrl(
        "@10",
        start,
        stop,
        "19,22"
        );

    QNetworkRequest request(url);
    request.setHeader(
        QNetworkRequest::UserAgentHeader,
        "Quantum Space Explorer/1.0"
        );
    request.setTransferTimeout(20000);
    request.setAttribute(
        QNetworkRequest::Http2AllowedAttribute,
        false
        );

    QNetworkReply *reply = manager.get(request);

    connect(
        reply,
        &QNetworkReply::finished,
        this,
        [this, reply]() {
            handleReply(reply, false);
        }
        );
}

void VoyagerManager::handleReply(
    QNetworkReply *reply,
    bool earthRequest
    )
{
    QString errorMessage;

    QString earthDistance = "Unavailable";
    QString sunDistance = "Unavailable";
    QString speed = "Unavailable";
    QString lightTime = "Unavailable";

    if (reply->error() != QNetworkReply::NoError)
    {
        errorMessage = reply->errorString();
        qDebug() << "JPL Horizons network error:" << errorMessage;
    }
    else
    {
        const QByteArray bytes = reply->readAll();
        qDebug() << "JPL response size:" << bytes.size();

        const QJsonDocument document = QJsonDocument::fromJson(bytes);

        if (!document.isObject())
        {
            errorMessage = "JPL returned invalid JSON.";
        }
        else
        {
            const QJsonObject root = document.object();

            if (root.contains("error"))
            {
                errorMessage = root.value("error").toString();

                if (errorMessage.isEmpty())
                    errorMessage = "JPL Horizons returned an error.";

                qDebug() << "JPL Horizons error:" << errorMessage;
            }
            else
            {
                const QString result = root.value("result").toString();
                const QString line = firstDataLine(result);

                qDebug() << "JPL data line:" << line;

                if (line.isEmpty())
                {
                    errorMessage = "JPL returned no ephemeris data.";
                }
                else
                {
                    const QStringList parts = line.split(',');

                    if (earthRequest)
                    {
                        /*
                         * Observed Horizons format for 20,21,22:
                         *
                         * [0] time
                         * [1] blank
                         * [2] blank
                         * [3] range km
                         * [4] range-rate km/s
                         * [5] light time minutes
                         * [6] Sun-relative speed km/s
                         * [7] observer-relative speed km/s
                         */

                        if (parts.size() >= 8)
                        {
                            double rangeKm = 0.0;
                            double lightMinutes = 0.0;
                            double sunSpeed = 0.0;

                            const bool rangeOK = numberFromField(
                                parts[3], rangeKm
                                );

                            const bool lightOK = numberFromField(
                                parts[5], lightMinutes
                                );

                            const bool speedOK = numberFromField(
                                parts[6], sunSpeed
                                );

                            if (rangeOK)
                            {
                                earthDistance =
                                    formatDistance(rangeKm) + "\n" +
                                    formatAU(rangeKm);

                                qDebug()
                                    << "REAL Voyager-Earth distance:"
                                    << rangeKm << "km";
                            }

                            if (lightOK)
                            {
                                lightTime = formatLightTime(lightMinutes);

                                qDebug()
                                    << "REAL Voyager light time:"
                                    << lightMinutes << "minutes";
                            }

                            if (speedOK)
                            {
                                speed = formatSpeed(sunSpeed);

                                qDebug()
                                    << "REAL Voyager speed:"
                                    << sunSpeed << "km/s";
                            }

                            if (!rangeOK || !lightOK || !speedOK)
                                errorMessage = "Could not parse Voyager Earth telemetry.";
                        }
                        else
                        {
                            errorMessage = "Unexpected Voyager Earth data format.";
                            qDebug() << "Earth parts:" << parts;
                        }
                    }
                    else
                    {
                        /*
                         * For 19,22 the useful fields are the final four:
                         *
                         * [n-4] heliocentric range km
                         * [n-3] heliocentric range-rate km/s
                         * [n-2] Sun-relative speed km/s
                         * [n-1] observer-relative speed km/s
                         */

                        if (parts.size() >= 7)
                        {
                            const int n = parts.size();

                            double rangeKm = 0.0;
                            double sunSpeed = 0.0;

                            const bool rangeOK = numberFromField(
                                parts[n - 4], rangeKm
                                );

                            const bool speedOK = numberFromField(
                                parts[n - 2], sunSpeed
                                );

                            if (rangeOK)
                            {
                                sunDistance =
                                    formatDistance(rangeKm) + "\n" +
                                    formatAU(rangeKm);

                                qDebug()
                                    << "REAL Voyager-Sun distance:"
                                    << rangeKm << "km";
                            }

                            if (speedOK)
                            {
                                speed = formatSpeed(sunSpeed);

                                qDebug()
                                    << "REAL Voyager speed from Sun query:"
                                    << sunSpeed << "km/s";
                            }

                            if (!rangeOK || !speedOK)
                                errorMessage = "Could not parse Voyager Sun telemetry.";
                        }
                        else
                        {
                            errorMessage = "Unexpected Voyager Sun data format.";
                            qDebug() << "Sun parts:" << parts;
                        }
                    }
                }
            }
        }
    }

    reply->deleteLater();

    static QString latestEarth = "Unavailable";
    static QString latestSun = "Unavailable";
    static QString latestSpeed = "Unavailable";
    static QString latestLight = "Unavailable";
    static QString latestError;

    if (!errorMessage.isEmpty())
    {
        latestError = errorMessage;
        qDebug() << "VOYAGER PARSE ERROR:" << latestError;
    }
    else if (earthRequest)
    {
        latestEarth = earthDistance;
        latestSpeed = speed;
        latestLight = lightTime;
    }
    else
    {
        latestSun = sunDistance;

        // If the Sun query supplies a valid speed, use it as well.
        if (speed != "Unavailable")
            latestSpeed = speed;
    }

    --pendingRequests;

    if (pendingRequests > 0)
        return;

    const QString updated =
        QDateTime::currentDateTimeUtc().toString(
            "dd MMM yyyy • hh:mm:ss UTC"
            );

    if (!latestError.isEmpty())
    {
        emit telemetryError(latestError);

        emit telemetryReady(
            latestEarth,
            latestSun,
            latestSpeed,
            latestLight,
            updated,
            "JPL ERROR"
            );

        qDebug() << "VOYAGER UPDATE FAILED:" << latestError;
    }
    else
    {
        emit telemetryReady(
            latestEarth,
            latestSun,
            latestSpeed,
            latestLight,
            updated,
            "LIVE • JPL HORIZONS"
            );

        qDebug() << "VOYAGER UPDATE SUCCESS";
    }

    latestError.clear();
}

QString VoyagerManager::formatDistance(double km)
{
    if (!std::isfinite(km))
        return "Unavailable";

    return QString::number(km, 'f', 0) + " km";
}

QString VoyagerManager::formatAU(double km)
{
    if (!std::isfinite(km))
        return "Unavailable";

    return QString::number(km / AU_KM, 'f', 3) + " AU";
}

QString VoyagerManager::formatLightTime(double minutes)
{
    if (!std::isfinite(minutes))
        return "Unavailable";

    const double hours = minutes / 60.0;

    if (hours >= 1.0)
        return QString::number(hours, 'f', 2) + " hours";

    return QString::number(minutes, 'f', 1) + " minutes";
}

QString VoyagerManager::formatSpeed(double kmPerSecond)
{
    if (!std::isfinite(kmPerSecond))
        return "Unavailable";

    const double auPerYear =
        kmPerSecond * 31557600.0 / AU_KM;

    return QString::number(kmPerSecond, 'f', 2) +
           " km/s\n" +
           QString::number(auPerYear, 'f', 3) +
           " AU/year";
}
