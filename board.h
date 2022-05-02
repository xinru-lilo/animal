#ifndef BOARD_H
#define BOARD_H

#include <qobject.h>
#include <QQmlListProperty>
#include <QPoint>
#include <QStack>

#include "chess.h"

//存储每一步信息的结构
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
    //通过索引值传递对应的当前棋子可以走的路径信息给ui
    Q_INVOKABLE QPoint getPath(int idx);
    Q_INVOKABLE int getPathesSize();
    Q_INVOKABLE QVariantList getLastStep();
     //点击棋子的响应事件
    Q_INVOKABLE virtual void clickChess(int id);
    //移动棋子到相关的path
    Q_INVOKABLE virtual void clickPath(int row, int col);
    //悔棋
    Q_INVOKABLE virtual void clickUndo();
    Q_INVOKABLE virtual void clickSum(){};
    Q_INVOKABLE virtual void applySum(int /*value*/){};
    Q_INVOKABLE virtual void clickLose(){};
    //超时
    Q_INVOKABLE void timeout();
    //net    
    Q_INVOKABLE virtual void createGame(){};
    Q_INVOKABLE virtual bool joinGame(QString /*srvIP*/){return false;};
    Q_INVOKABLE virtual QString getIP(){return "";};
    Q_INVOKABLE virtual void sendMasg(QString /*masg*/){};

signals:
    //通知ui棋子的路径已更新
    void pathesChange(int size);
    //向ui传递该棋子位置信息已变更，以便在ui端更新棋子位置
    void moveChess(int id);
    //通知ui被“复活”棋子的信息
    void statChange(int id);
    //通知ui转换对弈方
    void turnChange();
    void win(bool isRed);

    void netConnected();
    void moveTo(int id,int row,int col);

    void newMessage(QString msg);
    void askSum();
    void answerSum(int value);
    void oppoDefeat();

    void timerRestart();
protected:
    void initChess(bool isRed = false);
    void setClickId(int id);
    void turn();
    QList<Chess*> getChesses();
    //

    int getChessId(int row, int col);
    void canMovePath(int id);
    QList<QPoint> getPathes();

private:
    bool canMove(int fromid,int torow, int tocol);
    bool isRiver(int row, int col);
    bool isOppoTrap(int id);
    bool isWin();

private:
    //双方棋子信息
    QList<Chess*> m_chesses;
     //保存走过棋子的步骤，为悔棋做准备
    QStack<Step> m_steps;
     //当前是否为红方
    bool m_isRedTurn;
    //准备要走的棋子
    int m_clickedId;
    //准备要走的棋子的可以走的路径
    QList<QPoint> m_pathes;
};

#endif // BOARD_H
