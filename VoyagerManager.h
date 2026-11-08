#ifndef VOYAGERMANAGER_H
#define VOYAGERMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QUrl>
#include <QDateTime>

class VoyagerManager : public QObject
{
    Q_OBJECT

public:
    explicit VoyagerManager(QObject *parent = nullptr);

    Q_INVOKABLE void updateVoyager1();

signals:
    void telemetryReady(const QString &earthDistance,
                        const QString &sunDistance,
                        const QString &speed,
                        const QString &lightTime,
                        const QString &updated,
                        const QString &status);

    void telemetryError(const QString &message);

private:
    QNetworkAccessManager manager;
    int pendingRequests = 0;

    void fetchEarthData(const QDateTime &start,
                        const QDateTime &stop);

    void fetchSunData(const QDateTime &start,
                      const QDateTime &stop);

    void handleReply(QNetworkReply *reply,
                     bool earthRequest);

    QUrl makeHorizonsUrl(const QString &center,
                         const QDateTime &start,
                         const QDateTime &stop,
                         const QString &quantities) const;

    static QString formatDistance(double km);
    static QString formatAU(double km);
    static QString formatLightTime(double minutes);
    static QString formatSpeed(double kmPerSecond);
};

#endif