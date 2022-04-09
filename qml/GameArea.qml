import QtQuick 2.0
import Felgo 3.0

Item {

    id: gameArea

    width: blockSize * 9
    height: blockSize * 7
    ListModel{id:mod}

    property double blockSize
    property int rows: Math.floor(height / blockSize)
    property int columns: Math.floor(width / blockSize)
    property var arr: []

    function index(row, column) {
        return row * columns + column
    }

    function initializeField() {
        //c++init board()
        for (let i = 0; i!== Board.chess.lenth; i++){

            var entityProperties = {
                width: blockSize,
                height: blockSize,
                x: Board.chess[i].col * blockSize,
                y: Board.chess[i].row * blockSize,

                type: Board.chess[i].type, // random type
                row: Board.chess[i].row,
                col: Board.chess[i].col,
                isRed: Board.chess[i].isRed

            }

            // add block to game area
            var id = entityManager.createEntityFromUrlWithProperties(
                        Qt.resolvedUrl("Chess.qml"), entityProperties)
            console.log(Board.chess[i].row)
            console.log(Board.chess[i].col)
        }


    }


}
