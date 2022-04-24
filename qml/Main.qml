import Felgo 3.0
import QtQuick 2.0
import "scenes"

GameWindow {
    id: gameWindow

    state: "start"
    activeScene: startScene

//    onSplashScreenFinished: startScene.start()
    screenWidth: 640
    screenHeight: 960

    StartScene{
        id:startScene
        onButtonClicked: {
            if(pattern!==2){
                gameWindow.state = "board"
                boardScene.initBoard()
            }else{
                gameWindow.state = "connect"
                connectScene.initConnectBoard()
            }
        }
    }

    ConnectScene{
        id:connectScene
        visible: false
        onButtonClicked: {
            gameWindow.state = "board"
            boardScene.initBoard()
        }
        onBack: gameWindow.state = "start"
    }

    BoardScene{
        id:boardScene
        visible: false
        onBack: gameWindow.state = "start"
    }

    states: [
        State {
            name: "start"
            PropertyChanges {
                target: gameWindow
                activeScene:startScene
            }
        },
        State {
            name: "connect"
            PropertyChanges {
                target: connectScene
                visible:true
            }
            PropertyChanges {
                target: startScene
                visible:false
            }
        },
        State {
            name: "board"
            PropertyChanges {
                target: boardScene
                visible: true
            }
            PropertyChanges {
                target: startScene
                visible:false
            }
            PropertyChanges {
                target: connectScene
                visible:false
            }
            PropertyChanges {
                target: gameWindow
                activeScene: boardScene
            }
        }
    ]

}
