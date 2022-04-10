import QtQuick 2.0
import Felgo 3.0

Item {
    property alias source: img.source
    width: blockSize
    height: width
    BackgroundImage{
        id: img
        anchors.centerIn: parent
        source: "../../assets/img/Trap.png"
    }

}
