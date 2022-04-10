#ifndef ANIMAL_H
#define ANIMAL_H

#include <QObject>

#include "board.h"

class Animal : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Board * Board MEMBER m_board)
public:
    enum Mode {
        Double,
        Smart,
        Network
    };
    explicit Animal(QObject *parent = nullptr);
    ~Animal();

    int run(int argc, char *argv[]);

    Q_INVOKABLE void selectMode(int mode);

signals:

private slots:

private:
    Board* m_board;
};

#endif // ANIMAL_H
