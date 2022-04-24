#include "animal.h"
#include "net_board.h"
#include "single_board.h"

#include <QApplication>
#include <FelgoApplication>

#include <QQmlApplicationEngine>

#include <QQmlContext>
#include <QVariant>
#include <QtDebug>

Animal::Animal(QObject *parent)
    : QObject(parent)
    , m_board{nullptr}
{
}

Animal::~Animal()
{
    if (m_board)
        delete m_board;
    m_board = nullptr;
}

int Animal::run(int argc, char *argv[])
{
    QApplication app(argc, argv);

    FelgoApplication felgo;

    QQmlApplicationEngine engine;
    felgo.initialize(&engine);

    felgo.setLicenseKey(PRODUCT_LICENSE_KEY);

    felgo.setMainQmlFileName(QStringLiteral("qml/Main.qml"));

    qmlRegisterType<Chess>();
    engine.rootContext()->setContextObject(this);

    engine.load(QUrl(felgo.mainQmlFileName()));

    return app.exec();
}

void Animal::selectMode(int mode)
{
    if (m_board)
        delete m_board;
    m_board = nullptr;
    switch (mode) {
    case Animal::Double:
        m_board = new Board();
        break;
    case Animal::Smart:
        m_board = new SingleBoard();
        break;
    case Animal::Network:
        m_board = new NetBoard();
        break;
    }
}

void Animal::exit()
{
    if (m_board)
        delete m_board;
    m_board = nullptr;
}
