#ifndef NETGAME_H
#define NETGAME_H

#include "board.h"

#include <QTcpServer>
#include <QTcpSocket>


class NetBoard : public Board
{
public:
    NetBoard();
    ~NetBoard();

    void clickChess(int id) override;
    void clickPath(int row, int col) override;
    void clickUndo() override;
    void clickSum() override;
    void applySum(int value) override;
    void clickLose() override;

    void createGame() override;
    bool joinGame(QString srvIP) override;
    QString getIP() override;
    void sendMasg(QString masg) override;

private slots:
    void onNewConnection();
    void onRead();
    void onDisconnected();
protected:
    bool creatNewConnect(QString srvIP);

private:
    QTcpServer* m_server;
    QTcpSocket* m_socket;
    bool m_isRed;
};

#endif // NETGAME_H
