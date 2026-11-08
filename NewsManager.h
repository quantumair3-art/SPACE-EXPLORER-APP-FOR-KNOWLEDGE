#ifndef NEWSMANAGER_H
#define NEWSMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QUrl>

class NewsManager : public QObject
{
    Q_OBJECT

public:

    explicit NewsManager(
        QObject *parent = nullptr
        );

    Q_INVOKABLE void fetchNews();

signals:

    void newsReady(
        const QString &json
        );

    void newsError(
        const QString &message
        );

private:

    QNetworkAccessManager manager;

    void fetchFeed(
        const QUrl &url
        );
};

#endif