#include "single_board.h"
#include<qdebug.h>
#include <QTimer>

SingleBoard::SingleBoard():m_isRed{true}
{
    chesses = getChesses();
}

void SingleBoard::clickChess(int id)
{
    if(isRedTurn())
        return;

    if(!isRedTurn())
        Board::clickChess(id);
}

void SingleBoard::clickPath(int row, int col){
    Board::clickPath(row,col);
    qDebug()<<"clickPath():"<<row<<col;
    if(isRedTurn()){
        qDebug() <<"computerMove()";
        QTimer::singleShot(100,this,&SingleBoard::computerMove);
//        computerMove();
    }
}

void SingleBoard::computerMove()
{
    Step step = computerGetBestMove();
    qDebug() <<"cumputermove to:"<<step.toRow<<step.toCol;
    setClickId(step.moveId);
    clickPath(step.toRow,step.toCol);
//    if(chesses[step.killId]->isDead())
//        qDebug()<<step.killId<<"is die";

}

Step SingleBoard::computerGetBestMove()
{
    QList<Step> steps;
    getAllPossibleMove(steps);
    int level = 5;
//    qDebug() <<"getAllPossibleMove()";
    int maxScore = -100000;
    Step ret;
    for(auto it = steps.begin();it!=steps.end();++it){
        Step step = *it;
        fakeMove(step);
        int score = getMinScore(level-1,maxScore);
        unfakeMove(step);
        if(score>maxScore){
            maxScore = score;
            ret = step;
        }
    }

    return ret;

}

void SingleBoard::getAllPossibleMove(QList<Step> &steps)
{
//    qDebug() <<"getAllPossibleMove";
    int min =0;
    int max = 8;
    if(isRedTurn()){
        min=8;
        max=16;
    }
    for(int i = min;i<max;++i){
//        qDebug()<<"i"<<i;
        if(chesses[i]->isDead())
            continue;
        canMovePath(i);
        auto pathes = getPathes();
        for(auto j = 0;j<pathes.size();++j){
            auto ret = getChessId(pathes[j].y(),pathes[j].x());
            steps.append({i,ret,chesses[i]->row(),chesses[i]->col(),pathes[j].y(),pathes[j].x()});
//            qDebug()<<"i"<<i<<"ret"<<ret<<"row"<<pathes[j].y()<<"col"<<pathes[j].x();

        }
    }

}

int SingleBoard::getMinScore(int level,int curMaxScore)
{
    if(level == 0) return calScore();

    QList<Step> steps;
    getAllPossibleMove(steps);

    int minScore = 100000;
    for(auto it = steps.begin();it!=steps.end();++it){
        Step step = *it;
        fakeMove(step);
        int score = getMaxScore(level-1,minScore);
        unfakeMove(step);

        if(score<=curMaxScore)
            return score;
        if(score<minScore){
            minScore = score;
        }
    }
    return minScore;
}
int SingleBoard::getMaxScore(int level,int curMinScore)
{
    if(level == 0) return calScore();

    QList<Step> steps;
    getAllPossibleMove(steps);

    int maxScore = -100000;
    for(auto it = steps.begin();it!=steps.end();++it){
        Step step = *it;
        fakeMove(step);
        int score = getMinScore(level-1,maxScore);
        unfakeMove(step);

        if(score>=curMinScore)
            return score;

        if(score>maxScore){
            maxScore = score;
        }
    }
    return maxScore;
}
void SingleBoard::fakeMove(Step step)
{
    chesses[step.moveId]->moveTo(step.toRow,step.toCol);
    if(step.killId!=-1){
        chesses[step.killId]->die();
    }
    turn();
//    setClickId(step.moveId);
//    Board::clickPath(step.toRow,step.toCol);
}

void SingleBoard::unfakeMove(Step step)
{
    if(step.killId!=-1&&chesses[step.killId]->isDead())
        chesses[step.killId]->resurgence();
    chesses[step.moveId]->moveTo(step.fromRow,step.fromCol);
    turn();
//    setClickId(step.moveId);
//    Board::clickPath(step.fromRow,step.fromCol);
}

int SingleBoard::calScore()
{
    int bluescore = 0;
    int redscore = 0;
    int chessesScore[] = {248,254,277,312,375,418,457,514};
    for(int i = 0;i<8;++i){
        if(chesses[i]->isDead())
            continue;
        bluescore += chessesScore[chesses[i]->type()];
    }
    for(int i = 8;i<16;++i){
        if(chesses[i]->isDead())
            continue;
        redscore += chessesScore[chesses[i]->type()];
    }
    return redscore-bluescore;
}
