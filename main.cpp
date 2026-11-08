
#include "reportmanager.h"
#include <QQmlContext>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "NewsManager.h"
#include "VoyagerManager.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Report submission manager
    ReportManager reportManager;
    engine.rootContext()->setContextProperty(
        "reportManager", &reportManager);

    // Live NASA news manager
    NewsManager newsManager;
    engine.rootContext()->setContextProperty("newsManager", &newsManager);

    // Live NASA/JPL Voyager 1 telemetry manager
    VoyagerManager voyagerManager;
    engine.rootContext()->setContextProperty("voyagerManager", &voyagerManager);

    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl)
        {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection
        );

    engine.load(url);

    return QGuiApplication::exec();
}