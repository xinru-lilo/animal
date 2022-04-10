#include <QApplication>
#include <FelgoApplication>

#include <QQmlApplicationEngine>

#include <QQmlContext>
#include <QVariant>

#include "animal.h"

// uncomment this line to add the Live Client Module and use live reloading with your custom C++ code
//#include <FelgoLiveClient>

int main(int argc, char *argv[])
{
    Animal animal;
    return animal.run(argc, argv);
}
