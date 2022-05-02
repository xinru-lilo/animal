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
    property bool isNetPattern: false
    signal back
    signal win(int which,int who)
    signal sum()

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
        y:9*gameArea.blockSize+50
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 80
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
                boardScene.sum()
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
                if(isNetPattern){
                    chatArea.visible = false
                    edit.clear()
                    chatInput.clear()
                    isNetPattern = false;
                }
                entityManager.removeAllEntities()
                timer.stop()
                back()
                exit()  
            }
        }
    }



    AppText {
        id: timeText
    }

    Column{
        id:chatArea
        visible: false
        y:9*gameArea.blockSize+150
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20
        MyTextEdit{
            id:edit
            width: 600
            height: 200
            readOnly: true
            Rectangle{
                anchors.fill: parent
                color: "#18A259"
                opacity: 0.8
                radius: 8
                z: -1
            }
        }

        Row{
            spacing: 40
            AppTextInput{
                id:chatInput
                width: 450
                height: 50

                font.pixelSize: 30
                Rectangle{
                    anchors.fill: parent
                    color: "#18A259"
                    opacity: 0.7
                    radius: 4
                    z: -1
                }
            }

            ComButton{
                id:chatButton
                width: 100
                height: 50
                buttonText.text: qsTr("发送")
                enabled: chatInput.text.length
                onClicked: {
                    edit.append("Me:"+chatInput.text)
                    Board.sendMasg(chatInput.text)
                    chatInput.clear()
                }
            }
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
        Board.newMessage.connect(onNewMessage)
        entityManager.removeAllEntities()
        timerRestart()
        gameArea.initializeField();
        if(isNetPattern)
            chatArea.visible = true
    }

    function timerRestart() {
        time = 30
        timer.restart()
        timeText.text = time.toString()
//        console.log("timer restart")
    }
    function onNewMessage(msg) {
        edit.append("friend:"+msg)
    }

}
