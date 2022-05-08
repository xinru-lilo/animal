import QtQuick 2.0
import Felgo 3.0
import "../common"

// EMPTY SCENE

Scene {
    id:startScene
    width: 750
    height: 1300

    signal buttonClicked(int pattern)

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
    2.任何人一方中途认输，对方获胜。
    3.在双方同意的情况下可和棋"),qsTr("确定"))
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
}
