import QtQuick 2.0
import Felgo 3.0
import QtQuick.Controls 2.5
import "../common"

// EMPTY SCENE

Scene {
    id:gameoverScene
    width: 750
    height: 1300

    property bool isNetPattern: false
    property bool isSinglePattern: false
    property int netWho: 1
    property alias editext: edit1.text

    signal back

    BackgroundImage{
        source: "../../assets/img/chessboard.png"
        anchors.centerIn: gameoverScene.gameWindowAnchorItem
    }

    Rectangle{
        anchors.fill: parent
        color: "#FFFFFF"
        opacity: 0.2
    }

    Image {
        id: whowin
        width: 490
        height: 216
        y:240
        anchors.horizontalCenter: parent.horizontalCenter
        Image {
            id: gameoverbg
            source: "../../assets/img/gameoverbg.png"
            width: 400
            height: 300
            y:100
            z:-1
            x:35

            Rectangle{
                color: "#8B4513"
                y:100
                width: parent.width-58
                height: 60
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    id:edit1
                    anchors.centerIn: parent
                    font.pixelSize: 30
                    color: "#FFFFFF"
                }
            }

            Rectangle{
                color: "#8B4513"
                y:190
                width: parent.width-58
                height: 60
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    id:edit2
                    anchors.centerIn: parent
                    font.pixelSize: 30
                    color: "#FFFFFF"
                }
            }
        }
    }

    ComButton{
        id: backButton
        y:730
        x:260
        width: 200
        height: 70
        buttonText.text: qsTr("返回")
        onClicked: {
            if(isNetPattern)
                isNetPattern = false
            if(isSinglePattern)
                isSinglePattern = false
            back()
        }
    }

    function changeImage(which,who){
        if(isNetPattern){
            if(which===1){
                if(who===netWho)
                    whowin.source =  "../../assets/img/win.png"
                else
                    whowin.source = "../../assets/img/lose.png"
            }else if(which===0)
                whowin.source = "../../assets/img/sum.png"
        }else if(isSinglePattern){
            if(which===0)
                whowin.source = "../../assets/img/sum.png"
            else if(which===1)
                whowin.source = "../../assets/img/lose.png"
        }else{
            if(which===0)
                whowin.source = "../../assets/img/sum.png"
            else if(which===1)
                whowin.source = "../../assets/img/win.png"
        }
    }

    function changeText(which,who){
        if(which===0){
            edit1.text = "红方          平局"
            edit2.text = "蓝方          平局"
        }else if(which===1){
            if(who===1){
                edit1.text ="红方          胜利"
                edit2.text = "蓝方          失败"
            }else{
                edit1.text ="蓝方          胜利"
                edit2.text = "红方         失败"
            }
        }
    }
}
