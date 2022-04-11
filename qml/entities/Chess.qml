import QtQuick 2.0
import Felgo 3.0

EntityBase {

    id:chess
    entityType: "chess"

    property int type
    property int row
    property int col
    property int index
    property bool isRed
    property alias turn: mask.visible
    property alias enable: mouse.enabled

    Image {
        anchors.centerIn: parent

        source: {
            if (index == 0)
                return "../../assets/img/Mice.png"
            else if(index === 1)
                return "../../assets/img/Cat.png"
            else if (index === 2)
                return "../../assets/img/Dog.png"
            else if (index === 3)
                return "../../assets/img/Wolf.png"
            else if(index === 4)
                return "../../assets/img/Leopard.png"
            else if(index === 5)
                return "../../assets/img/Tiger.png"
            else if(index === 6)
                return "../../assets/img/Lion.png"
            else if(index === 7)
                return "../../assets/img/Elephant.png"
            else if (index === 8)
                return "../../assets/img/Mice_r.png"
            else if(index === 9)
                return "../../assets/img/Cat_r.png"
            else if (index === 10)
                return "../../assets/img/Dog_r.png"
            else if (index === 11)
                return "../../assets/img/Wolf_r.png"
            else if(index === 12)
                return "../../assets/img/Leopard_r.png"
            else if(index === 13)
                return "../../assets/img/Tiger_r.png"
            else if(index === 14)
                return "../../assets/img/Lion_r.png"
            else if(index === 15)
                return "../../assets/img/Elephant_r.png"
        }

    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: Board.clickChess(index)
    }

    Rectangle {
        id: mask
        anchors.fill: parent
        color: "red"
        radius: 8
        opacity: 0.2
    }

}
