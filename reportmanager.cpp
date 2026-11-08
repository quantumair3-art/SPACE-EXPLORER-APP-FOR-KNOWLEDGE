
#include "ReportManager.h"

#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonObject>
#include <QJsonDocument>
#include <QUrl>

ReportManager::ReportManager(QObject *parent)
    : QObject(parent)
{
}

void ReportManager::submitReport(const QString &category,
                                 const QString &subject,
                                 const QString &message)
{
    if (category.trimmed().isEmpty() ||
        subject.trimmed().isEmpty() ||
        message.trimmed().isEmpty()) {
        emit submissionFinished(
            false, "Please complete all report fields.");
        return;
    }

    QUrl url("http://127.0.0.1/quantum_reports/submit_report.php");

    QNetworkRequest request(url);
    request.setHeader(
        QNetworkRequest::ContentTypeHeader,
        "application/json");

    QJsonObject report;
    report["category"] = category.trimmed();
    report["subject"] = subject.trimmed();
    report["message"] = message.trimmed();
    report["app_version"] = "1.0";

    const QByteArray json =
        QJsonDocument(report).toJson(QJsonDocument::Compact);

    QNetworkReply *reply = networkManager.post(request, json);

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        const int statusCode =
            reply->attribute(
                     QNetworkRequest::HttpStatusCodeAttribute).toInt();

        const QByteArray response = reply->readAll();
        const auto networkError = reply->error();

        if (networkError == QNetworkReply::NoError &&
            statusCode >= 200 && statusCode < 300) {
            emit submissionFinished(
                true, "Report submitted successfully.");
        } else {
            emit submissionFinished(
                false,
                QString("Submission failed (HTTP %1). Check XAMPP and the API.")
                    .arg(statusCode));
        }

        reply->deleteLater();
    });
}
