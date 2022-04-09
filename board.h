#ifndef BOARD_H
#define BOARD_H
#include "chess.h"
#include <qobject.h>
#include <QQmlListProperty>

class Board: public QObject
{
    Q_OBJECT
public:
    Board();
    ~Board();
public:
    Q_PROPERTY(QQmlListProperty<Chess> chess READ getChess)

    void initChess();
    QQmlListProperty<Chess> getChess();
    Q_INVOKABLE void click(int row, int col);

private:
    QList<Chess*> m_chess;
    bool m_isRedTurn;
};

#endif // BOARD_H
