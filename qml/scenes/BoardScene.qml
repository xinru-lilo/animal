import QtQuick 2.0
import Felgo 3.0
import QtQuick.Controls 2.0
import "../common"

// EMPTY SCENE

Scene {
    id: boardScene

    width: 750
    height: 1300

    property int time: 30
    signal back

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

    Row{
        x: 30
        y:9*gameArea.blockSize+50
        spacing: 50
        //悔棋按钮
        ComButton{
            id: undoButton
            width: 100
            height: 70
            buttonText.text: qsTr("悔棋")
            onClicked: {
                Board.clickUndo()
                timerRestart()
            }
        }

        ComButton{
            id: sumButton
            width: 100
            height: 70
            buttonText.text: qsTr("求和")
            onClicked: {
    //            Board.clickUndo()
                timerRestart()
            }
        }

        ComButton{
            id: losingButton
            width: 100
            height: 70
            buttonText.text: qsTr("认输")
            onClicked: {
    //            Board.clickUndo()
                timerRestart()
            }
        }

        ComButton{
            id: backButton
            width: 100
            height: 70
            buttonText.text: qsTr("返回")
            onClicked: {
                entityManager.removeAllEntities()
                exit()
                back()
                timer.stop()
            }
        }
    }



    AppText {
        id: timeText
    }

    Column{
        y:9*gameArea.blockSize+150
        spacing: 40
        MyTextEdit{
            id:edit
            width: 200
            height: 200
            readOnly: true
            Rectangle{
                anchors.fill: parent
                color: "#FFFFFF"
                z: -1
            }
        }

        TextEdit{
            id:chatInput
            width: 200
            height: 50
            Rectangle{
                anchors.fill: parent
                color: "#FFFFFF"
                z: -1
            }
        }

        AppButton{
            onClicked: edit.append("aaaa")
        }
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
            timeText.text = "time:"+time.toString()
        }
    }

    function initBoard(){
        timerRestart()
        gameArea.initializeField();
    }

    function timerRestart() {
        time = 30
        timer.restart()
        timeText.text = time.toString()
        console.log("timer restart")
    }

}
