#include "board.h"

#include <QDebug>

Board::Board()
{
//    m_chess.reserve(16);
//    m_chess.re
}

Board::~Board()
{

}

void Board::initChess(){
    for(int i=0;i<16;i++){
        this->m_chess.append(new Chess());
        this->m_chess[i]->init(i);
    }

}

QQmlListProperty<Chess> Board::getChess()
{
    return QQmlListProperty<Chess>(this, m_chess);
}

void Board::click(int row, int col)
{
    qDebug()<<row<<" "<<col;
}

//QVariantList Board::getChess()
//{
//    return QVariantList::fromVector(m_chess);
//}
