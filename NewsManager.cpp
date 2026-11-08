#include "NewsManager.h"

#include <QNetworkRequest>
#include <QNetworkReply>
#include <QXmlStreamReader>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QDebug>

NewsManager::NewsManager(QObject *parent)
    : QObject(parent)
{
}

void NewsManager::fetchNews()
{
    QUrl url("https://www.nasa.gov/rss/dyn/breaking_news.rss");

    fetchFeed(url);
}

void NewsManager::fetchFeed(const QUrl &url)
{
    QNetworkRequest request(url);

    // Identify the application
    request.setHeader(
        QNetworkRequest::UserAgentHeader,
        "Quantum Space Explorer/1.0"
        );

    // IMPORTANT:
    // Disable HTTP/2 because NASA's feed can sometimes
    // produce HTTP/2 protocol errors with Qt on Windows.
    request.setAttribute(
        QNetworkRequest::Http2AllowedAttribute,
        false
        );

    // Give the request enough time to complete.
    request.setTransferTimeout(15000);

    QNetworkReply *reply = manager.get(request);

    connect(reply, &QNetworkReply::finished,
            this,
            [this, reply]()
            {
                // ----------------------------------------------------
                // NETWORK ERROR
                // ----------------------------------------------------

                if (reply->error() != QNetworkReply::NoError)
                {
                    QString errorMessage =
                        reply->errorString();

                    qDebug()
                        << "News download error:"
                        << errorMessage;

                    emit newsError(errorMessage);

                    reply->deleteLater();
                    return;
                }

                // ----------------------------------------------------
                // READ NASA RSS DATA
                // ----------------------------------------------------

                QByteArray data =
                    reply->readAll();

                QXmlStreamReader xml(data);

                QJsonArray newsArray;

                // ----------------------------------------------------
                // PARSE RSS ITEMS
                // ----------------------------------------------------

                while (!xml.atEnd())
                {
                    xml.readNext();

                    if (!xml.isStartElement())
                        continue;

                    if (xml.name() != "item")
                        continue;

                    QString title;
                    QString description;
                    QString link;
                    QString date;

                    while (!xml.atEnd())
                    {
                        xml.readNext();

                        // End of <item>
                        if (xml.isEndElement() &&
                            xml.name() == "item")
                        {
                            break;
                        }

                        if (!xml.isStartElement())
                            continue;

                        QString tag =
                            xml.name().toString();

                        if (tag == "title")
                        {
                            title =
                                xml.readElementText();
                        }
                        else if (tag == "description")
                        {
                            description =
                                xml.readElementText();
                        }
                        else if (tag == "link")
                        {
                            link =
                                xml.readElementText();
                        }
                        else if (tag == "pubDate")
                        {
                            date =
                                xml.readElementText();
                        }
                    }

                    // ------------------------------------------------
                    // ADD ARTICLE
                    // ------------------------------------------------

                    if (!title.isEmpty())
                    {
                        QJsonObject article;

                        article["title"] =
                            title.trimmed();

                        article["description"] =
                            description.trimmed();

                        article["link"] =
                            link.trimmed();

                        article["date"] =
                            date.trimmed();

                        article["source"] =
                            "NASA";

                        newsArray.append(article);
                    }
                }

                // ----------------------------------------------------
                // XML ERROR
                // ----------------------------------------------------

                if (xml.hasError())
                {
                    qDebug()
                    << "NASA RSS XML error:"
                    << xml.errorString();

                    emit newsError(
                        "Could not read NASA news feed."
                        );

                    reply->deleteLater();
                    return;
                }

                // ----------------------------------------------------
                // CONVERT TO JSON
                // ----------------------------------------------------

                QJsonDocument document(
                    newsArray
                    );

                QString json =
                    QString::fromUtf8(
                        document.toJson(
                            QJsonDocument::Compact
                            )
                        );

                qDebug()
                    << "NASA news articles:"
                    << newsArray.size();

                // ----------------------------------------------------
                // SEND DATA TO QML
                // ----------------------------------------------------

                emit newsReady(json);

                reply->deleteLater();
            });
}