import QtQuick 2.0
import Felgo 3.0
import "../common"

// EMPTY SCENE

Scene {
    id: boardScene

    width: 750
    height: 1300

    property int time: 30

    BackgroundImage{
        source: "../../assets/img/chessboard.png"
        anchors.centerIn: boardScene.gameWindowAnchorItem
    }

    EntityManager {
      id: entityManager
      entityContainer: gameArea
    }


    GameArea {
      id: gameArea
      anchors.horizontalCenter: boardScene.horizontalCenter
      y:147
      blockSize: 79
      onPathesChange: {
          for(let i=0;i<gameArea.pathes.length;++i){
              gameArea.pathes[i].timerRestart.connect(timerRestart)
          }
      }
    }

    AppButton{
        id:undoButton
        x:20
        y:9*gameArea.blockSize
        width: 80
        text: "undo"
        onClicked: {
            Board.clickUndo()
            timerRestart()
        }
    }
    AppButton{
        id:sumButton
        x:200
        y:9*gameArea.blockSize
        width:80
        text: "sum"
        onClicked: {
//            Board.clickUndo()
            timerRestart()
        }
    }
    AppButton{
        id:losingButton
        x:400
        y:9*gameArea.blockSize
        width:80
        text: "losing"
        onClicked: {
//            Board.clickUndo()
            timerRestart()
        }
    }

    AppText {
        id: timeText
    }

    Timer{
        id:timer
        interval: 1000
        repeat: true
        onTriggered:{
            time--
            if (!time) {
                Board.timeout()
                gameArea.clearPathes()
                timerRestart()
            }
            timeText.text = time.toString()
        }
    }

    function start(){
        timer.start()
        gameArea.initializeField();
    }

    function timerRestart() {
        time = 30
        timer.restart()
        timeText.text = time.toString()
        console.log("timer restart")
    }

}
