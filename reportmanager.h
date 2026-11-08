
#ifndef REPORTMANAGER_H
#define REPORTMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>

class ReportManager : public QObject
{
    Q_OBJECT

public:
    explicit ReportManager(QObject *parent = nullptr);

    Q_INVOKABLE void submitReport(const QString &category,
                                  const QString &subject,
                                  const QString &message);

signals:
    void submissionFinished(bool success, const QString &message);

private:
    QNetworkAccessManager networkManager;
};

#endif // REPORTMANAGER_H
