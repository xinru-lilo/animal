#ifndef SINGLE_BOARD_H
#define SINGLE_BOARD_H
#include "board.h"

#include <QObject>

class SingleBoard : public Board
{
    Q_OBJECT
public:
    SingleBoard();
public:
    void clickChess(int id) override;
    void clickPath(int row, int col) override;
    void computerMove();
    Step computerGetBestMove();
    void getAllPossibleMove(QList<Step> &steps);
    int getMinScore(int level,int curMaxScore);
    int getMaxScore(int level,int curMinScore);
    void fakeMove(Step step);
    void unfakeMove(Step step);
    int calScore();
private:
    bool m_isRed;
    QList<Chess *> chesses;

};

#endif // SINGLE_BOARD_H
