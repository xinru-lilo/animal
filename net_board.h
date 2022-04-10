#ifndef NETGAME_H
#define NETGAME_H

#include "board.h"

#include <QTcpServer>
#include <QTcpSocket>


class NetBoard : public Board
{
public:
    NetBoard();

    void clickChess(int id) override;
    void clickPath(int row, int col) override;
    void clickUndo() override;

    Q_INVOKABLE void createGame() override;
    Q_INVOKABLE void joinGame(QString srvIP) override;
    QString getIP() override;

private slots:
    void onNewConnection();
    void onRead();

private:
    QTcpServer* m_server;
    QTcpSocket* m_socket;
    bool m_isRed;
};

#endif // NETGAME_H
