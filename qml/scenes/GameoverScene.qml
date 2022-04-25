import QtQuick 2.0
import Felgo 3.0
import "../common"

// EMPTY SCENE

Scene {
    id:gameoverScene
    width: 750
    height: 1300

    property int value: 1
    property int who: 1
    property bool isNetPattern: false
    property int netWho: 1

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
        source: {
            if(isNetPattern){
                if(value===1){
                    if(who===netWho)
                        return "../../assets/img/win.png"
                    else
                        return "../../assets/img/lose.png"
                }
            }else{
                if(value===0)
                    return "../../assets/img/sum.png"
                else if(value===1)
                    return "../../assets/img/win.png"
            }
        }
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
                TextEdit{
                    anchors.centerIn: parent
                    readOnly: true
                    font.pixelSize: 30
                    color: "#FFFFFF"
                    text:{
                        if(who==1)
                            return "红方          胜利"
                        else
                            return  "红方         失败"
                    }
                }
            }

            Rectangle{
                color: "#8B4513"
                y:190
                width: parent.width-58
                height: 60
                anchors.horizontalCenter: parent.horizontalCenter
                TextEdit{
                    anchors.centerIn: parent
                    readOnly: true
                    font.pixelSize: 30
                    color: "#FFFFFF"
                    text:{
                        if(who==1)
                            return "蓝方          失败"
                        else
                            return  "蓝方         胜利"
                    }
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
            back()
        }
    }
}
