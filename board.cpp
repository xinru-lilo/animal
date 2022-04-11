#include "board.h"
#include "chess.h"

#include <QDebug>

Board::Board(): m_isRedTurn{false}, m_clickedId{-1}
{
    initChess();
}

Board::~Board()
{

}

bool Board::isRedTurn()
{
    return m_isRedTurn;
}

QQmlListProperty<Chess> Board::getChess()
{
    return QQmlListProperty<Chess>(this, m_chess);
}

QPoint Board::getPath(int idx)
{
    return m_pathes[idx];
}

int Board::getPathesSize()
{
    return m_pathes.size();
}

QVariantList Board::getLastStep()
{
    QVariantList lastStep;
    if (!m_steps.empty()) {
        auto step = m_steps.top();
        lastStep.append(step.moveId);
        lastStep.append(step.fromRow);
        lastStep.append(step.fromCol);
    }
    return lastStep;
}

void Board::initChess(bool isRed){
    this->m_chess.clear();
    for(int i=0;i<16;i++){
        this->m_chess.append(new Chess());
        this->m_chess[i]->init(i, isRed);
    }
}

void Board::clickChess(int id)
{
    qDebug()<<"click: ("<<m_chess[id]->row()<<","<<m_chess[id]->col()<<"),type:"<<m_chess[id]->type();
    if (m_chess[id]->isRed() != m_isRedTurn)
        return;
    m_clickedId = id;
    m_pathes.clear();
    canMovePath(m_clickedId);
}

void Board::clickPath(int row, int col)
{
    int id = getChessId(row, col);
    auto fromrow = m_chess[m_clickedId]->row();
    auto fromcol = m_chess[m_clickedId]->col();

    m_chess[m_clickedId]->moveTo(row, col);

    if (id != -1) {
        m_chess[id]->die();
        emit statChange(id);
    }
    m_steps.push({m_clickedId,id,fromrow,fromcol,row,col});

    emit moveChess(m_clickedId);

    if(isWin())
        emit win(m_chess[m_clickedId]->isRed());
    turn();
    m_clickedId = -1;
}

void Board::clickUndo()
{
    if(m_steps.size() < 2)
        return;
    auto step = m_steps.pop();
    m_chess[step.moveId]->moveTo(step.fromRow, step.fromCol);
    emit moveChess(step.moveId);
    if (step.killId != -1) {
        m_chess[step.killId]->resurgence();
        emit statChange(step.killId);
    }

    step = m_steps.pop();
    m_chess[step.moveId]->moveTo(step.fromRow, step.fromCol);
    emit moveChess(step.moveId);
    if (step.killId != -1) {
        m_chess[step.killId]->resurgence();
        emit statChange(step.killId);
    }
//    turn();
}

void Board::timeout()
{
    turn();
}

void Board::setClickId(int id)
{
    m_clickedId = id;
}

void Board::canMovePath(int id)
{
    int direct[]={-1,0,1,0,-1};
    int row = m_chess[id]->row();
    int col = m_chess[id]->col();
    auto type = m_chess[id]->type();
    switch (type) {
    case Chess::Mice:
        for(int i=0;i<4;++i){
            auto x = col + direct[i];
            auto y = row + direct[i+1];
            if(x>=0 && x<9 && y>=0 && y<7 && canMove(y,x))
                m_pathes.append({x, y});
        }
        break;
    case Chess::Lion:
    case Chess::Tiger:
        for(int i=0;i<4;++i){
            auto x=col+direct[i];
            auto y=row+direct[i+1];
            if(x>=0 && x<9 && y>=0 && y<7) {
                while (isRiver(y, x)){
                    int ret = getChessId(y,x);
                    if (ret != -1 && m_chess[m_clickedId]->isRed()!= m_chess[ret]->isRed())
                        break;
                    x += direct[i];
                    y += direct[i+1];
                }
                if (!isRiver(y, x) && canMove(y, x))
                    m_pathes.append({x, y});
            }
        }
        break;
    default:
        for(int i=0;i<4;++i){
            auto x=col+direct[i];
            auto y=row+direct[i+1];
            if(x>=0 && x<9 && y>=0 && y<7 && !isRiver(y, x) && canMove(y,x))
                m_pathes.append({x, y});
        }
        break;
    }

    emit pathesChange(m_pathes.size());
}

bool Board::canMove(int row, int col)
{
    auto ret = getChessId(row,col);
    if(ret==-1)
        return true;
    else if(m_chess[m_clickedId]->isRed()!= m_chess[ret]->isRed()){
        auto clickType = m_chess[m_clickedId]->type();
        auto retType = m_chess[ret]->type();
        if(isOppoTrap(ret)){
            return true;
        }
        if(clickType == Chess::Mice && retType == Chess::Elephant
                && !isRiver(m_chess[m_clickedId]->row(),m_chess[m_clickedId]->col())) {
            return true;
        } else if (clickType >= retType
                   && (!(clickType == Chess::Elephant && retType == Chess::Mice))) {
            return true;
        }
    }

    return false;
}

//得到该row、col上面的棋子
int Board::getChessId(int row, int col)
{
    for(int i=0; i<16; ++i)
    {
        if(m_chess[i]->row() == row && m_chess[i]->col() == col && !m_chess[i]->isDead())
            return i;
    }

    return -1;    //该row、col上没有棋子
}

bool Board::isRiver(int row, int col)
{
    if(row>0&&row<3&&col>2&&col<6)
        return true;
    else if(row>3&&row<6&&col>2&&col<6)
        return true;
    else
        return false;
}

bool Board::isOppoTrap(int id)
{
    auto row = m_chess[id]->row();
    auto col = m_chess[id]->col();
    if(m_chess[id]->isRed()) {
        if((row==2&&col==0) || (row==3&&col==1) || (row==4&&col==0))
            return true;
    } else
        if((row==2&&col==8) || (row==3&&col==7) || (row==4&&col==8))
            return true;
    return false;
}

bool Board::isWin()
{
    auto row = m_chess[m_clickedId]->row();
    auto col = m_chess[m_clickedId]->col();
    if(m_chess[m_clickedId]->isRed()) {
        if(row==3&&col==0)
            return true;
    } else
        if(row==3&&col==8)
            return true;
    return false;
}

void Board::turn()
{
    m_isRedTurn = !m_isRedTurn;
    emit turnChange();
}
