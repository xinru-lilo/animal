import Felgo 3.0
import QtQuick 2.0
import "scenes"

GameWindow {
    id: gameWindow

    state: "start"
    activeScene: startScene

//    state: "board"
//    activeScene: boardScene

//    onSplashScreenFinished: startScene.start()
    screenWidth: 640
    screenHeight: 960

    StartScene{
        id:startScene
        onButtonClicked: {
            if(pattern===0){
                gameWindow.state = "board"
                boardScene.initBoard()            

            }else if(pattern===1){
                gameWindow.state = "board"
                boardScene.isSinglePattern = true;
                gameoverScene.isSinglePattern = true
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
            boardScene.isMe = who
            boardScene.initBoard()
        }
        onBack: {
            gameWindow.state = "start"
            boardScene.isNetPattern = false
        }
        onNetPattern: {
            gameoverScene.isNetPattern = true;
            gameoverScene.netWho = who;
            boardScene.isNetPattern = true;
        }
    }

    BoardScene{
        id:boardScene
        visible: false
        onBack: gameWindow.state = "start"
        onWin: {
            gameoverScene.changeImage(which,who)
            gameoverScene.changeText(which,who)
            gameWindow.state = "gameover"
        }
        onSum: {
            gameoverScene.changeImage(which,1)
            gameoverScene.changeText(which,1)
            gameWindow.state = "gameover"
        }
    }

    GameoverScene{
        id:gameoverScene
        visible: false
        onBack: {
            boardScene.isNetPattern = false
            boardScene.isSinglePattern = false
            gameWindow.state = "start"
        }
    }

    states: [
        State {
            name: "start"
            PropertyChanges {
                target: gameWindow
                activeScene:startScene
            }
            PropertyChanges {
                target: gameoverScene
                visible: false
            }
            PropertyChanges {
                target: boardScene
                visible: false
            }
            PropertyChanges {
                target: connectScene
                visible:false
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
            PropertyChanges {
                target: gameWindow
                activeScene:connectScene
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
        },
        State {
            name: "gameover"
            PropertyChanges {
                target: gameWindow
                activeScene: gameoverScene
            }
            PropertyChanges {
                target: gameoverScene
                visible: true
            }
            PropertyChanges {
                target: boardScene
                visible: false
            }
        }
    ]

}
