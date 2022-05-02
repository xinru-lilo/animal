import QtQuick 2.0

Rectangle {
    id: root
    color: "transparent"
    opacity: 0.0
    property alias enabled: mouseArea.enabled
    property int dialogWidth: 500
    property int dialogHeight: 300
    state: enabled ? "on" : "baseState"

    signal ok
    signal cancel

    states: [
        State {
            name: "on"
            PropertyChanges {
                target: root
                opacity: 1.0
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "*"
            NumberAnimation {
                properties: "opacity"
                easing.type: Easing.OutQuart
                duration: 500
            }
        }
    ]

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "black"
        opacity: 0.3
    }

    Image {
        anchors.centerIn: parent
        width: dialogWidth
        height: dialogHeight
        source: "../../assets/img/gameoverbg.png"

        Text {
            id: text
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: okBtn.top
            anchors.margins: 10
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "#FFFFFF"
            font.pixelSize: 40
            wrapMode: Text.WordWrap
        }

        ComButton{
            id: okBtn
            y:200
            x:50
            width: 200
            height: 70
            buttonText.text: qsTr("OK")
            onClicked: {
                ok()
                root.enabled = false
            }
        }
        ComButton{
            id: cancelBtn
            y:200
            x:250
            width: 200
            height: 70
            buttonText.text: qsTr("Cancel")
            onClicked: {
                cancel()
                root.enabled = false
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        z:-1
    }

    function show(msg) {
        text.text = msg
        root.enabled = true
    }
}
