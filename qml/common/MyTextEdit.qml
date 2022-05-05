import QtQuick 2.0
import Felgo 3.0
import QtQuick.Controls 2.5

Item {

    id: item

    property alias text: textEdit.text
    property alias readOnly: textEdit.readOnly
    property alias font: textEdit.font
    property alias horizontalAlignment: textEdit.horizontalAlignment
    property alias verticalAlignment:textEdit.verticalAlignment
    property alias color: textEdit.color
    property alias wrapMode: textEdit.wrapMode
    ScrollView{
        id:view
        anchors.fill: parent
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        TextArea{
            id:textEdit
            text: ""
            font.pixelSize: dp(16)
        }
    }

    function append(str) {
        textEdit.append(str)
    }
    function clear(){
        textEdit.clear()
    }
}
