#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFile>
#include "Utilities.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);

    StoreCredits storeLogin;
    ISSAPI issBackend;
    StargazeWeatherAPI stargazeBackend;

    // Connect C++ objects to QML
    engine.rootContext()->setContextProperty("storeLogin", &storeLogin);
    engine.rootContext()->setContextProperty("issBackend", &issBackend);
    engine.rootContext()->setContextProperty("stargazeBackend", &stargazeBackend);

    QString qmlFilePath = QCoreApplication::applicationDirPath() + "/Main.qml";

    if (!QFile::exists(qmlFilePath)) {
        qmlFilePath = "D:/JASAEspacio/Main.qml";
    }

    const QUrl url = QUrl::fromLocalFile(qmlFilePath);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
