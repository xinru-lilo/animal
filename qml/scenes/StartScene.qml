import QtQuick 2.0
import Felgo 3.0

// EMPTY SCENE

Scene {
    id:startScene
    signal doubleButtonClicked
    signal smartButtonClicked
    signal netButtonClicked

    BackgroundImage{
        source: "../../assets/img/background.jpg"
        anchors.centerIn: startScene.gameWindowAnchorItem
    }

    AppButton{
        id: doubleButton
        text: "doubleGame"
        x: 10
        onClicked: {
            selectMode(0);
            startScene.doubleButtonClicked()
        }
    }
    AppButton{
        id: smartButton
        text: "smartGame"
        x: 100
        onClicked: {
            selectMode(1);
            startScene.smartButtonClicked()
        }
    }
    AppButton{
        id: netButton
        text: "netGame"
        x: 200
        onClicked: {
            selectMode(2);
            doubleButton.visible = false;
            smartButton.visible = false;
            netButton.visible = false;

            createButton.visible = true;
            joinButton.visible = true;
        }
    }

    // network
    AppButton{
        id: createButton
        text: "CreateGame"
        x: 200
        y: 100
        visible: false
        onClicked: {
            Board.createGame()

            createButton.visible = false
            joinButton.visible = false
            ip.visible = true;
            Board.connected.connect(onConnected)
            ip.text = Board.getIP()
        }
    }

    AppButton{
        id: joinButton
        text: "JoinGame"
        x: 200
        y: 200
        visible: false
        onClicked: {
            createButton.visible = false
            joinButton.visible = false

            ipInput.visible = true
            ipButton.visible = true
        }
    }

    // show ip
    Text {
        id: ip;
        anchors.centerIn: parent
        text: "ssssssssssssss"
        width: 100
        height: 20
        visible: false
    }

    // input ip
    TextEdit {
        id: ipInput
        anchors.centerIn: parent
        color: "red"

        width: 100
        height: 20
        visible: false
        Rectangle{
            anchors.fill: parent
            color: "#FFFFFF"
            z: -1
        }
    }

    AppButton{
        id: ipButton
        text: "Join"
        anchors.top: ipInput.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
        onClicked: {
            Board.joinGame(ipInput.text)
            startScene.doubleButtonClicked()
        }
    }

    function onConnected() {
        startScene.doubleButtonClicked()
    }

}
