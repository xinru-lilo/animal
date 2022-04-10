#ifndef BOARD_H
#define BOARD_H

#include <qobject.h>
#include <QQmlListProperty>
#include <QPoint>
#include <QStack>

#include "chess.h"

struct Step{
    int moveId;
    int killId;
    int fromRow;
    int fromCol;
    int toRow;
    int toCol;
};

class Board: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<Chess> chess READ getChess)
public:
    Board();
    ~Board();

    bool isRedTurn();
public:
    QQmlListProperty<Chess> getChess();
    Q_INVOKABLE QPoint getPath(int idx);
    Q_INVOKABLE int getPathesSize();
    Q_INVOKABLE virtual void clickChess(int id);
    Q_INVOKABLE virtual void clickPath(int row, int col);
    Q_INVOKABLE virtual void clickUndo();
    Q_INVOKABLE void timeout();
    Q_INVOKABLE virtual void createGame(){};
    Q_INVOKABLE virtual void joinGame(QString /*srvIP*/){};
    Q_INVOKABLE virtual QString getIP(){return "";};
signals:
    void pathesChange(int size);
    void moveChess(int id);
    void statChange(int id);
    void turnChange();
    void win(bool isRed);
    void connected();

protected:
    void initChess(bool isRed = false);
    void setClickId(int id);
    void turn();

private:
    void canMovePath(int id);
    bool canMove(int row, int col);
    int getChessId(int row, int col);
    bool isRiver(int row, int col);
    bool isOppoTrap(int id);
    bool isWin();

private:
    QList<Chess*> m_chess;
    QStack<Step> m_steps;
    bool m_isRedTurn;
    int m_clickedId;
    QList<QPoint> m_pathes;
};

#endif // BOARD_H
