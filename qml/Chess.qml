import QtQuick 2.0
import Felgo 3.0

EntityBase {

    id:chess
    entityType: "chess"

    property int type
    property int row
    property int col
    property bool isRed

    Image {
        anchors.centerIn: parent

        source: {
            if(!isRed){
                if (type == 0)
                    return "../assets/img/Mice.png"
                else if(type == 1)
                    return "../assets/img/Cat.png"
                else if (type == 2)
                    return "../assets/img/Dog.png"
                else if (type == 3)
                    return "../assets/img/Wolf.png"
                else if(type == 4)
                    return "../assets/img/Leopard.png"
                else if(type == 5)
                    return "../assets/img/Tiger.png"
                else if(type == 6)
                    return "../assets/img/Lion.png"
                else
                    return "../assets/img/Elephant.png"
            }else{
                if (type == 0)
                    return "../assets/img/Mice_r.png"
                else if(type == 1)
                    return "../assets/img/Cat_r.png"
                else if (type == 2)
                    return "../assets/img/Dog_r.png"
                else if (type == 3)
                    return "../assets/img/Wolf_r.png"
                else if(type == 4)
                    return "../assets/img/Leopard_r.png"
                else if(type == 5)
                    return "../assets/img/Tiger_r.png"
                else if(type == 6)
                    return "../assets/img/Lion_r.png"
                else
                    return "../assets/img/Elephant_r.png"
            }
        }

    }
    MouseArea {
        anchors.fill: parent
        onClicked: Board.click(row, col)
    }

}
