#include "net_board.h"

#include <QtNetwork>

NetBoard::NetBoard()
    : m_server{nullptr}
    , m_socket{nullptr}
    , m_isRed{false}
{
}

void NetBoard::clickChess(int id)
{
    if ((isRedTurn() ^ m_isRed) || !m_socket)
        return;
    Board::clickChess(id);
    char buf[2];
    buf[0] = 0;
    buf[1] = id;
    m_socket->write(buf, 2);
}

void NetBoard::clickPath(int row, int col)
{
    Board::clickPath(row, col);
    char buf[3];
    buf[0] = 1;
    buf[1] = row;
    buf[2] = col;
    m_socket->write(buf, 3);
}

void NetBoard::clickUndo()
{
    if (isRedTurn() ^ m_isRed)
        return;
    Board::clickUndo();
    char buf = 2;
    m_socket->write(&buf, 1);
}

void NetBoard::createGame()
{
    m_server = new QTcpServer(this);      // 创建服务器socket
    m_server->listen(QHostAddress::Any, 9999);   // 监听
//    QString ip = getIP();
    connect(m_server, &QTcpServer::newConnection, this, &NetBoard::onNewConnection);
}

void NetBoard::joinGame(QString srvIP)
{
    m_isRed = true;
    m_socket = new QTcpSocket(this);   // 创建客户端socket
    m_socket->connectToHost(QHostAddress(srvIP), 9999);   // 连接
    // 当有数据发送过来时，触发信号，调用槽函数
    connect(m_socket, &QTcpSocket::readyRead, this, &NetBoard::onRead);
}

QString NetBoard::getIP()
{
    QList<QHostAddress> list = QNetworkInterface::allAddresses();
    foreach (QHostAddress addr, list) {
        if (addr.protocol() == QAbstractSocket::IPv4Protocol
                && addr != QHostAddress::LocalHost)
            return  addr.toString();
    }
    return "127.0.0.1";
}

void NetBoard::onNewConnection()
{
    if (m_socket)
        return;

    // 接收连接，等同于C语言里的accept，返回值类似于C语言里的文件描述符
    m_socket = m_server->nextPendingConnection();
    // 当有客户端数据发送过来时，触发信号，调用槽函数
    connect(m_socket, &QTcpSocket::readyRead, this, &NetBoard::onRead);
    qDebug() <<"newConnect";
    emit connected();
}

void NetBoard::onRead()
{
    QByteArray buf = m_socket->readAll();
    char cmd = buf[0];
    switch (cmd) {
    case 0: {
        int id = buf[1];
        setClickId(id);
        break;
    }
    case 1: {
        int row = buf[1];
        int col = buf[2];
        Board::clickPath(row, col);
        break;
    }
    case 2: {
        Board::clickUndo();
        break;
    }
    default:
        break;
    }
}
