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
    property bool isSinglePattern: false
    property int isMe: 0
    signal back
    signal win(int which,int who)
    signal sum(int which)

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
                if(isNetPattern)
                    Board.clickSum()
                else
                    boardScene.sum(0)
            }
        }

        ComButton{
            id: losingButton
            visible: false
            width: 100
            height: 70
            buttonText.text: qsTr("认输")
            onClicked: {

                if(isNetPattern){
                    Board.clickLose()
                    boardScene.win(1,1-isMe)
                }
                if(isSinglePattern)
                    boardScene.win(1,1)
            }
        }

        ComButton{
            id: backButton
            width: 100
            height: 70
            buttonText.text: qsTr("返回")
            onClicked: backDialog.show(2,qsTr("您确定要返回吗？"))
        }
    }

    Rectangle{
        width: 220
        height: 40
        color: "#ccff00"
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 0.5
        y:80
        Text {
            id: timeText
            text: qsTr("")
            font.pixelSize: 28
            anchors.centerIn: parent
        }
    }

    Column{
        x:640
        y:20
        ComButton{
            id:ruleButton
            width: 72
            height: 44
            bg:"../../assets/img/rule.png"
            onClicked: {
                ruleDialog.visible = true
                ruleDialog.show(1,qsTr("一、斗兽棋的棋子
    斗兽棋棋子共十六个，分为红蓝双方（左侧一方为蓝方，右侧为红方），双方各有八只一样的棋子，按照战斗力强弱排列为：象>狮>虎>豹>狼>狗>猫>鼠。
    二、斗兽棋的走法
    1.游戏开始时，蓝方先走，然后轮流走棋。每次可走动一只兽，每只兽每次走一方格，前后左右均可，狮、虎、鼠还有不同走法。
    2.狮虎跳河法：狮虎在小河边时，可以纵横对直跳过小河，且能把小河对岸的敌方较小的兽类吃掉，但是如果对方老鼠在河里，把跳的路线阻隔就不能跳，若对岸是对方比自己战斗力强的兽，也不可以跳过小河；
    3.鼠游过河法：鼠是唯一可以走入小河的兽，走法同陆地上一样，每次走一格，上下左右均可，而且，陆地上的其他兽不可以吃小河中的鼠，小河中的鼠也不能吃陆地上的象，鼠类互吃不受小河影响。
    三、斗兽棋的吃法
    1.斗兽棋吃法分普通吃法和特殊吃法，普通吃法是按照兽的战斗力强弱，强者可以吃弱者。
    2.鼠吃象法：八兽的吃法除按照战斗力强弱之外，唯鼠能吃象，象不能吃鼠。
    3.互吃法：凡同类相遇，可以互吃。
    4.陷阱：走入敌方陷阱的兽会被限制战斗力，可被敌方任意棋子吃掉，若走进己方陷阱，则不受影响。
    四、斗兽棋胜负判定:
1.任何一方的兽走入敌方的兽穴就算胜利。
2.任何一方的棋子被吃光就算失败，对方胜利。
3.任何人一方中途认输，对方获胜。
4.在双方同意的情况下可和棋。"),qsTr("确定"))
            }
        }

        Rectangle{
            width: 72
            height: 40
            color: "#FFD700"
            z:-1
            Text {
                text: qsTr("规则")
                font.pixelSize: 28
                anchors.centerIn: parent
            }
        }
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
            wrapMode: Text.Wrap
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
            MyTextEdit{
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
            timeText.text = "时间剩余："+time.toString()+"秒"
        }
    }

    MyDialog{
        id:ruleDialog
        anchors.fill: parent
        dialogHeight:700
        dialogWidth: 550
        text.font.pixelSize: 30
        text.horizontalAlignment: Text.AlignLeft
        visible: false
        standardButtons: Dialog.DialogButton.Ok
        text.color:"Black"
        bgRect.visible: true
    }

    MyDialog{
        id:backDialog
        anchors.fill: parent
        visible: false
        standardButtons: Dialog.DialogButton.Ok | Dialog.DialogButton.Cancel
        onAccepted: boardBack()
    }

    MyDialog{
        id:askSumDialog
        anchors.fill: parent
        visible: false
        standardButtons: Dialog.DialogButton.Ok | Dialog.DialogButton.Cancel
        onAccepted: {
            Board.applySum(1);
            boardScene.sum(0)
        }
        onRejected: Board.applySum(0)
    }

    MyDialog{
        id:tipsDialog
        anchors.fill: parent
        visible: false
        standardButtons: Dialog.DialogButton.Ok
    }

    MyDialog{
        id:tipDialog
        anchors.fill: parent
        visible: false
        standardButtons: Dialog.DialogButton.Ok
        onAccepted: boardScene.win(1,isMe)
    }

    MyDialog{
        id:disconnectedDialog
        anchors.fill: parent
        visible: false
        standardButtons: Dialog.DialogButton.Ok
        onAccepted: boardBack()
    }

    function initBoard(){
        Board.timerRestart.connect(timerRestart)
        Board.newMessage.connect(onNewMessage)
        Board.askSum.connect(onAskSum)
        Board.answerSum.connect(onAnswerSum)
        Board.oppoDefeat.connect(onOppoDefeat)
        Board.disconnected.connect(onDisconnected)

        entityManager.removeAllEntities()
        timerRestart()
        gameArea.initializeField();
        chatArea.visible = false
        edit.clear()
        chatInput.clear()
        losingButton.visible = false;
        disconnectedDialog.visible = false;

        if(isNetPattern){
            chatArea.visible = true
            losingButton.visible = true
        }
        if(isSinglePattern)
            losingButton.visible = true
    }

    function timerRestart() {
        time = 30
        timer.restart()
        timeText.text = "时间剩余："+time.toString()+"秒"
//        console.log("timer restart")
    }
    function onNewMessage(msg) {
        edit.append("friend:"+msg)
    }
    function onAskSum(){
        askSumDialog.show(2,qsTr("对方求和，您是否同意？"), qsTr("同意"), qsTr("拒绝"))
    }
    function onAnswerSum(value){
        if(value===1)
            boardScene.sum(0)
        else{
            tipsDialog.show(1,qsTr("对方拒绝求和!"), qsTr("确定"))
        }
    }
    function onOppoDefeat(){
//        tipsDialog.text = qsTr("对方已认输!")
        tipDialog.show(1,qsTr("对方已认输!"), qsTr("确定"))
    }
    function onDisconnected(){
        disconnectedDialog.visible = true
        disconnectedDialog.show(1,qsTr("对方已断开链接"),qsTr("确定"))
    }
    function boardBack(){
        if(isNetPattern){
            chatArea.visible = false
            losingButton.visible = false
            edit.clear()
            chatInput.clear()
            isNetPattern = false;
            disconnectedDialog.visible = false
        }
        if(isSinglePattern){
            losingButton.visible = false
            isSinglePattern = false
        }
        entityManager.removeAllEntities()
        timer.stop()
        back()
        exit()
    }
}
