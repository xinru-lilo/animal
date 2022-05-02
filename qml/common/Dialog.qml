import QtQuick 2.0

Rectangle {
    id: root
    color: "transparent"
    opacity: 0.0
    property alias enabled: mouseArea.enabled
    property int dialogWidth: 500
    property int dialogHeight: 300
    property int standardButtons: Dialog.DialogButton.Ok | Dialog.DialogButton.Cancel
    state: enabled ? "on" : "baseState"

    enum DialogButton {
        Ok = 0x1,
        Cancel = 0x2
    }

    signal accepted
    signal rejected

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
            height: 200
            anchors.margins: 10
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "#FFFFFF"
            font.pixelSize: 40
            wrapMode: Text.WordWrap
        }

        Row {
            y: 180
            anchors.horizontalCenter: parent.horizontalCenter
            height: 70
            spacing: 5
            ComButton {
                id: okBtn
                width: 200
                height: 70
                buttonText.text: qsTr("OK")
                visible: standardButtons & Dialog.DialogButton.Ok
                onClicked: {
                    accepted()
                    root.enabled = false
                    root.z = -1
                }
            }
            ComButton {
                id: cancelBtn
                width: 200
                height: 70
                buttonText.text: qsTr("Cancel")
                visible: standardButtons & Dialog.DialogButton.Cancel
                onClicked: {
                    rejected()
                    root.enabled = false
                    root.z = -1
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        z:-1
    }

    function show(msg, leftBtn="OK", rightBtn="Cancel") {
        text.text = msg
        okBtn.buttonText.text = leftBtn
        cancelBtn.buttonText.text = rightBtn
        root.enabled = true
        root.z = 1000
    }
}
