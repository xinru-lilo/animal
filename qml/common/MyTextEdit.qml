import QtQuick 2.0
import Felgo 3.0
import QtQuick.Controls 2.5

Item {

    id: item

    property alias text: textEdit.text
    property alias readOnly: textEdit.readOnly
    property alias font: textEdit.font

    ScrollView{
        id:view
        anchors.fill: parent
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
