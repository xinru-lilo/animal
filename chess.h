#ifndef CHESS_H
#define CHESS_H
#include <QString>
#include <QObject>

class Chess:public QObject
{
    Q_OBJECT
    Q_PROPERTY(int row READ row /*WRITE setRow NOTIFY rowChanged*/)
    Q_PROPERTY(int col READ col /*WRITE setCol NOTIFY colChanged*/)
    Q_PROPERTY(int type READ type /*WRITE setCol NOTIFY colChanged*/)
    Q_PROPERTY(bool isRed READ isRed /*WRITE setCol NOTIFY colChanged*/)
    Q_PROPERTY(int ID READ ID /*WRITE setID NOTIFY IDChanged*/)
    Q_PROPERTY(bool isDead READ isDead /*WRITE setID NOTIFY IDChanged*/)
public:
    Chess(QObject *parent=0);
    ~Chess();

    int row();
    int col();
    int type();
    bool isRed();
    bool isDead();
    int ID();

public:
    enum TYPE{Mice,Cat,Dog,Wolf,Leo,Tiger,Lion,Elephant};

public:
    void init(int id, bool isRed);

    void moveTo(int row, int col);
    void die();
    //棋子“复活”
    void resurgence();

private:
    int m_row;
    int m_col;
    int m_ID;
    bool m_isRed;
    bool m_isDead;
    TYPE m_type;
};

#endif // CHESS_H
