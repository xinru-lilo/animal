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
    return QQmlListProperty<Chess>(this, m_chesses);
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

QList<QPoint> Board::getPathes()
{
    return m_pathes;
}

void Board::setClickId(int id)
{
    m_clickedId = id;
}

void Board::initChess(bool isRed){
    this->m_chesses.clear();
    for(int i=0;i<16;i++){
        this->m_chesses.append(new Chess());
        this->m_chesses[i]->init(i, isRed);
    }
}
//点击棋子的响应事件
void Board::clickChess(int id)
{
    qDebug()<<"click: ("<<m_chesses[id]->row()<<","<<m_chesses[id]->col()<<"),type:"<<m_chesses[id]->type();
    //如果没有轮到被点击棋子的相应方，则无响应
    if (m_chesses[id]->isRed() != m_isRedTurn)
        return;
    //保存被点击棋子的id作为准备要走的棋子
    m_clickedId = id;

//    //清空可以走的路径，方便更新
//    m_pathes.clear();

    //更新该棋子可以走的路径
    canMovePath(m_clickedId);
    qDebug() <<"m_clickedId"<<m_clickedId;

    //通知ui棋子的路径已更新
    emit pathesChange(m_pathes.size());
}

void Board::clickPath(int row, int col)
{
    int id = getChessId(row, col);
    auto fromrow = m_chesses[m_clickedId]->row();
    auto fromcol = m_chesses[m_clickedId]->col();

    //移动棋子到（row，col）
    m_chesses[m_clickedId]->moveTo(row, col);

    //吃掉当前位置的棋子
    if (id != -1) {
        m_chesses[id]->die();
        emit statChange(id);

    }
    //存储这个移动过程
    m_steps.push({m_clickedId,id,fromrow,fromcol,row,col});
    //向ui传递该棋子位置信息已变更
    emit moveChess(m_clickedId);

    if(isWin())
        emit win(m_chesses[m_clickedId]->isRed());
    //转换对弈方
    turn();
    emit turnChange();
    //更新，当前无已选择棋子
    m_clickedId = -1;

}

void Board::clickUndo()
{
    if(m_steps.size() < 2)
        return;
    auto step = m_steps.pop();
    //更新悔棋后棋子的位置
    m_chesses[step.moveId]->moveTo(step.fromRow, step.fromCol);
    emit moveChess(step.moveId);
    //让被吃掉的棋子“复活”
    if (step.killId != -1) {
        m_chesses[step.killId]->resurgence();
        //通知ui被“复活”棋子的信息
        emit statChange(step.killId);
    }

    step = m_steps.pop();
    m_chesses[step.moveId]->moveTo(step.fromRow, step.fromCol);
    emit moveChess(step.moveId);
    if (step.killId != -1) {
        m_chesses[step.killId]->resurgence();
        emit statChange(step.killId);
    }
//    turn();
//    emit turnChange();
}

//void Board::clickSum(){
//    emit
//}

void Board::timeout()
{
    turn();
    emit turnChange();
}

//更新棋子可以走的路径
void Board::canMovePath(int id)
{
    m_pathes.clear();
    int direct[]={-1,0,1,0,-1};
    int row = m_chesses[id]->row();
    int col = m_chesses[id]->col();
    auto type = m_chesses[id]->type();
    switch (type) {
    case Chess::Mice:
        for(int i=0;i<4;++i){
            auto x = col + direct[i];
            auto y = row + direct[i+1];
            if(x>=0 && x<9 && y>=0 && y<7 && canMove(id,y,x))
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
                    if (ret != -1 && m_chesses[id]->isRed()!= m_chesses[ret]->isRed())
                        break;
                    x += direct[i];
                    y += direct[i+1];
                }
                if (!isRiver(y, x) && canMove(id,y, x))
                    m_pathes.append({x, y});
            }
        }
        break;
    default:
        for(int i=0;i<4;++i){
            auto x=col+direct[i];
            auto y=row+direct[i+1];
            if(x>=0 && x<9 && y>=0 && y<7 && !isRiver(y, x) && canMove(id,y,x))
                m_pathes.append({x, y});
        }
        break;
    }
}

bool Board::canMove(int id,int row, int col)
{
    auto ret = getChessId(row,col);
    if(ret==-1)
        return true;
    else if(m_chesses[id]->isRed()!= m_chesses[ret]->isRed()){
        auto clickType = m_chesses[id]->type();
        auto retType = m_chesses[ret]->type();
        if(isOppoTrap(ret)){
            return true;
        }
        if(clickType == Chess::Mice && retType == Chess::Elephant
                && !isRiver(m_chesses[id]->row(),m_chesses[id]->col())) {
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
        if(m_chesses[i]->row() == row && m_chesses[i]->col() == col && !m_chesses[i]->isDead())
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
    auto row = m_chesses[id]->row();
    auto col = m_chesses[id]->col();
    if(m_chesses[id]->isRed()) {
        if((row==2&&col==0) || (row==3&&col==1) || (row==4&&col==0))
            return true;
    } else
        if((row==2&&col==8) || (row==3&&col==7) || (row==4&&col==8))
            return true;
    return false;
}

bool Board::isWin()
{
    auto row = m_chesses[m_clickedId]->row();
    auto col = m_chesses[m_clickedId]->col();
    auto total = 0;
    if(m_chesses[m_clickedId]->isRed()) {
        if(row==3&&col==0)
            return true;
        for(int i = 8;i<16;++i){
            if(m_chesses[i]->isDead())
                ++total;
        }
        if(total==8) return true;
    } else{
        if(row==3&&col==8)
            return true;
        for(int i = 0;i<8;++i){
            if(m_chesses[i]->isDead())
                ++total;
        }
        if(total==8) return true;
    }
    return false;
}

void Board::turn()
{
    m_isRedTurn = !m_isRedTurn;
//    emit turnChange();
}

QList<Chess*> Board::getChesses()
{
    return m_chesses;
}
