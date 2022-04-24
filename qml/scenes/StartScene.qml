import QtQuick 2.0
import Felgo 3.0
import "../common"

// EMPTY SCENE

Scene {
    id:startScene
    width: 750
    height: 1300

    signal buttonClicked(int pattern)
//    signal exited

    BackgroundImage{
        source: "../../assets/img/background.jpg"
        anchors.centerIn: startScene.gameWindowAnchorItem
    }

    Image {
        id: title
        source: "../../assets/img/title.png"
        y:80
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Column{
        x: 280
        y:540
        spacing: 50
        ComButton{
            id: doubleButton
            width: 200
            height: 70
            buttonText.text: qsTr("人人对战")
            onClicked: {
                selectMode(0);
                startScene.buttonClicked(0)
            }
        }

        ComButton{
            id: smartButton
            width: 200
            height: 70
            buttonText.text: qsTr("人机对战")
            onClicked: {
                selectMode(1);
                startScene.buttonClicked(1)
            }

        }

        ComButton{
            id: netButton
            width: 200
            height: 70
            buttonText.text: qsTr("好友约战")
            onClicked: {
                selectMode(2);
                startScene.buttonClicked(2)
            }

        }
    }
}
