import QtQuick 2.0
import Felgo 3.0
import "../common"

// EMPTY SCENE

Scene {
    id:connectScene

    width: 750
    height: 1300

    signal buttonClicked
    signal back
    signal netPattern(int who)

    BackgroundImage{
        source: "../../assets/img/background.jpg"
        anchors.centerIn: connectScene.gameWindowAnchorItem
    }

    Image {
        id: title
        source: "../../assets/img/title.png"
        y:80
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Column{
        y:540
        x: 280
        spacing: 50
        // network
        ComButton{
            id: createButton
            width: 200
            height: 70
            buttonText.text: qsTr("创建游戏")
            onClicked: {
                Board.createGame()
                createButton.visible = false
                joinButton.visible = false
                ip.visible = true;
                ip.text = Board.getIP()
                Board.netConnected.connect(onNetConnected)
                connectScene.netPattern(0)
            }
        }

        ComButton{
            id: joinButton
            width: 200
            height: 70
            buttonText.text: qsTr("加入游戏")
            onClicked: {
                createButton.visible = false
                joinButton.visible = false

                ipInput.visible = true
                ipButton.visible = true
                connectScene.netPattern(1)

            }
        }
    }

    // show ip
    Text {
        id: ip;
        anchors.centerIn: parent
        text: ""
        font.pixelSize: 50
        width: 300
        height: 20
        visible: false
    }

    Column{
        y:540
        x: 230
        spacing: 50
        // input ip
        TextEdit {
            id: ipInput
            color: "red"
            width: 300
            height: 50
            visible: false
            font.pixelSize: 40
            Rectangle{
                anchors.fill: parent
                color: "#FFFFFF"
                z: -1
            }
        }

        ComButton{
            id: ipButton
            x:50
            width: 200
            height: 70
            buttonText.text: qsTr("加入游戏")
            visible: false
            onClicked: {
                let ret = Board.joinGame(ipInput.text)
                console.log(ret)
                if(ret){
                    connectScene.buttonClicked()
                }
//                Board.netConnected.connect(onNetConnected)
            }

        }
    }

    ComButton{
        id: backButton
        y:830
        x:280
        width: 200
        height: 70
        buttonText.text: qsTr("返回")
        onClicked: {
            back()
        }
    }

    function initConnectBoard(){
        createButton.visible = true
        joinButton.visible = true

        ipInput.visible = false
        ipButton.visible = false
        ip.visible = false
        ipInput.clear()
    }

    function onNetConnected() {
        connectScene.buttonClicked()
        console.log("onNetConnected")
    }
}
