#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QQuickStyle>
#include "backend/PythonBridge.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/resources/icons/app-icon.png"));
    
    // Set material style for better mobile experience
    QQuickStyle::setStyle("Material");
    
    QQmlApplicationEngine engine;
    
    // Initialize Python bridge
    PythonBridge pythonBridge;
    engine.rootContext()->setContextProperty("pythonBridge", &pythonBridge);
    
    // Load main QML file
    engine.load(QUrl(QStringLiteral("qrc:/qml/MainWindow.qml")));
    
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}