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
public:
    Chess(QObject *parent=0);
    ~Chess();

    int row();
    int col();
    int type();
    bool isRed();

public:
    enum TYPE{mice,cat,dog,wolf,leo,tiger,lion,elephant};
    int m_row;
    int m_col;
    int m_ID;
    bool m_isRed;
    TYPE m_type;

public:
    void init(int ID);
};

#endif // CHESS_H
