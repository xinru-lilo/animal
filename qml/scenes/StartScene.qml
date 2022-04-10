import QtQuick 2.0
import Felgo 3.0

// EMPTY SCENE

Scene {
    id:startScene
    signal startButtonclicked

    BackgroundImage{
        source: "../../assets/img/background.jpg"
        anchors.centerIn: startScene.gameWindowAnchorItem
    }

    AppButton{
        id:boardButton
        onClicked: startScene.startButtonclicked()
    }

}
