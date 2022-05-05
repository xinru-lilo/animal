import QtQuick 2.0

Item {
    id: item

    opacity: 0.0
//    property alias enabled: mouseArea.enabled
    property int dialogWidth: 500
    property int dialogHeight: 300
    property int standardButtons: Dialog.DialogButton.Ok | Dialog.DialogButton.Cancel
    property alias text: myTextEdit
    property alias bgRect: bgRect

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
                target: item
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

        MyTextEdit {
            id: myTextEdit
            readOnly: true
            y:50
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width-80
            height: parent.height-180
            anchors.margins: 10
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            color: "#FFFFFF"
            font.pixelSize: 40
            Rectangle{
                id:bgRect
                anchors.fill: parent
                color: "#FFFFFF"
                z:-1
                opacity: 0.9
                visible: false
            }
        }

        Row {
            y: parent.height-120
            anchors.horizontalCenter: parent.horizontalCenter
            height: 70
            spacing: 5
            ComButton {
                id: okButton
                width: 200
                height: 70
                buttonText.text: qsTr("OK")
                visible: standardButtons & Dialog.DialogButton.Ok
                onClicked: {
                    accepted()
//                    item.enabled = false
                    item.visible = false
                    item.z = -1
//                    bgRect.visible = false
                }
            }
            ComButton {
                id: cancelButton
                width: 200
                height: 70
                buttonText.text: qsTr("Cancel")
                visible: standardButtons & Dialog.DialogButton.Cancel
                onClicked: {
                    rejected()
//                    item.enabled = false
                    item.visible = false
                    item.z = -1
//                    bgRect.visible = false
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
        myTextEdit.text = msg
        okButton.buttonText.text = leftBtn
        cancelButton.buttonText.text = rightBtn
//        item.enabled = true
        item.visible = true
        item.z = 1000
    }
}
