import QtQuick 2.0
import Felgo 3.0

Item {

    id: button

    property alias buttonText: buttonText
    property alias mouseArea: mouseArea
    property alias bg: bg.source

    signal clicked

    Image {
        id: bg
        anchors.fill:parent
        source: "../../assets/img/button1.png"
    }

    Text {
        id: buttonText
        anchors.centerIn: parent
        color: "black"
        font.pixelSize: 30
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
//        hoverEnabled: true
//        onEntered:
//        {
//            button.state="entered"
//            buttonSound.play()
//        }
//        onExited: button.state="exited"
        onPressed: button.opacity = 0.7
        onReleased: button.opacity = 1
        onClicked: button.clicked()
    }
}
