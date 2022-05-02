#include "net_board.h"
#include <QtNetwork>

NetBoard::NetBoard()
    : m_server{nullptr}
    , m_socket{nullptr}
    , m_isRed{false}
{
}

NetBoard::~NetBoard()
{
    if(m_socket){
        m_socket->close();
        delete m_socket;
        m_socket = nullptr;
    }
    if(m_server){
        m_server->close();
        delete m_server;
        m_server = nullptr;
    }
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

void NetBoard::sendMasg(QString masg)
{
    auto str = 3 + masg;
    QByteArray buf = str.toUtf8().data();
    m_socket->write(buf, buf.size());

}

void NetBoard::clickSum()
{
    if (isRedTurn() ^ m_isRed)
        return;
    char buf = 4;
    m_socket->write(&buf, 1);
}

void NetBoard::applySum(int value)
{
    char buf[2];
    buf[0] =5;
    buf[1] = value;
    m_socket->write(buf,2);
}

void NetBoard::clickLose()
{
    char buf = 6;
    m_socket->write(&buf, 1);
}

void NetBoard::createGame()
{
    m_server = new QTcpServer(this);      // 创建服务器socket
    m_server->listen(QHostAddress::Any, 9999);   // 监听
    m_server->setMaxPendingConnections(1);
    connect(m_server, &QTcpServer::newConnection, this, &NetBoard::onNewConnection);
}

bool NetBoard::joinGame(QString srvIP)
{
    m_isRed = true;
    m_socket = new QTcpSocket(this);   // 创建客户端socket
    m_socket->connectToHost(QHostAddress(srvIP), 9999);   // 连接
    qDebug()<<"socket state:"<<m_socket->state();
    if(!m_socket->waitForConnected())
        return false;
    connect(m_socket, &QTcpSocket::readyRead, this, &NetBoard::onRead);
    qDebug()<<"socket state:"<<m_socket->state();
    return true;
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

    if (m_socket){
        m_server->nextPendingConnection()->close();
        return;
    }
    // 接收连接，等同于C语言里的accept，返回值类似于C语言里的文件描述符
    m_socket = m_server->nextPendingConnection();
    // 当有客户端数据发送过来时，触发信号，调用槽函数
    connect(m_socket, &QTcpSocket::readyRead, this, &NetBoard::onRead);
    qDebug() <<"newConnect";
    emit netConnected();
}

void NetBoard::onRead()
{
    QByteArray buf = m_socket->readAll();
    char cmd = buf[0];
    qDebug()<<"cmd:"<<cmd;
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
        emit timerRestart();
        break;
    }
    case 2: {
        Board::clickUndo();
        break;
    }
    case 3: {
        QString msg = buf.mid(1);
        emit newMessage(msg);
        break;
    }
    case 4:{
        emit askSum();
        break;
    }
    case 5:{
        int value = buf[1];
        emit answerSum(value);
        break;
    }
    case 6:{
        emit oppoDefeat();
        break;
    }
    default:
        break;
    }
}


