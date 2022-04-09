#include "chess.h"

struct{
    int row;
    int col;
    Chess::TYPE type;
} pos[16]{
{6,2,Chess::mice},
{1,1,Chess::cat},
{5,1,Chess::dog},
{2,2,Chess::wolf},
{4,2,Chess::leo},
{0,0,Chess::tiger},
{6,0,Chess::lion},
{0,2,Chess::elephant}
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

void Chess::init(int ID){
    if(ID<8){
        this->m_row = pos[ID].row;
        this->m_col = pos[ID].col;
        this->m_type = pos[ID].type;
    }else{
        this->m_row = 6-pos[ID-8].row;
        this->m_col = 8-pos[ID-8].col;
        this->m_type = pos[ID-8].type;
    }
    this->m_ID = ID;
    this->m_isRed = (ID>=8);

}
