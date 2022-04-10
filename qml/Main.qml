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
        onStartButtonclicked: {
            gameWindow.state = "board"
            boardScene.start()
        }
    }

    BoardScene{
        id:boardScene
        visible: false
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
            name: "board"
            PropertyChanges {
                target: boardScene
                visible: true
            }
            PropertyChanges {
                target: gameWindow
                activeScene: boardScene
            }
        }
    ]

}
