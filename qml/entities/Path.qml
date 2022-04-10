import QtQuick 2.0
import Felgo 3.0

EntityBase {

    id:path
    entityType: "path"

    property int row
    property int col

    signal timerRestart()

    Rectangle{
        anchors.fill: parent
        color: "green"
        opacity: 0.5
        z: -1
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log(row,col);
            Board.clickPath(row, col)
            path.timerRestart()
        }

    }

}
