#include "chess.h"

struct{
    int row;
    int col;
    Chess::TYPE type;
} pos[16]{
{6,2,Chess::Mice},
{1,1,Chess::Cat},
{5,1,Chess::Dog},
{2,2,Chess::Wolf},
{4,2,Chess::Leo},
{0,0,Chess::Tiger},
{6,0,Chess::Lion},
{0,2,Chess::Elephant}
};
Chess::Chess(QObject */*parent*/)
{

}

Chess::~Chess()
{

}

int Chess::row()
{
    return m_row;
}

int Chess::col()
{
    return m_col;
}

int Chess::type()
{
    return m_type;
}

bool Chess::isRed()
{
    return m_isRed;
}

int Chess::ID()
{
    return m_ID;
}

void Chess::init(int id, bool isRed){
    if(id<8){
        this->m_row = pos[id].row;
        this->m_col = pos[id].col;
        this->m_type = pos[id].type;
    }else{
        this->m_row = 6-pos[id-8].row;
        this->m_col = 8-pos[id-8].col;
        this->m_type = pos[id-8].type;
    }
    this->m_ID = id;
    this->m_isRed = (id>=8)^isRed;
    this->m_isDead = false;

}

bool Chess::isDead()
{
    return m_isDead;
}

void Chess::moveTo(int row, int col)
{
    m_row = row;
    m_col = col;
}

void Chess::die()
{
    m_isDead = true;
}

void Chess::resurgence()
{
    m_isDead = false;
}
