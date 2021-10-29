#include <QApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>
#include "filter.h"
#include "databridge.h"
#include <iostream>
#include <filesystem>

int main(int argc, char *argv[])
{
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    app.setOrganizationName("lukamilosevic11");
    app.setOrganizationDomain("lukamilosevic11");
    app.setApplicationName("Video Editor by Lule");

    //creates folder where we store images of each frame
    if(!std::filesystem::exists("./editedImages")){
        std::filesystem::create_directory("editedImages");
    }

    //creates folder where we store edited videos
    if(!std::filesystem::exists("./editedVideos")){
        std::filesystem::create_directory("editedVideos");
    }

    DataBridge* db = DataBridge::GetInstance();
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    qmlRegisterType<Filter>("vEditor", 1, 0, "Filter");
    qmlRegisterType<DataBridge>("vEditor", 1, 0, "DataBridge");

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    QQmlContext* context = engine.rootContext();
    context->setContextProperty("_db", db);
    engine.load(url);

    return app.exec();
}
