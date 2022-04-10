import QtQuick 2.0
import Felgo 3.0

Item {

    id: gameArea

    width: blockSize * 9
    height: blockSize * 7

    property double blockSize
    property int rows: Math.floor(height / blockSize)
    property int columns: Math.floor(width / blockSize)
    property var chesses: []
    property var pathes: []
    property var otherImg: [[0,2], [1,3],[0,4],[8,2],[7,3],[8,4],[0,3],[8,3]]

    signal pathesChange()

    function initializeField() {

        initOther()

        initChesses()

        connectBoard()

    }

    function initChesses() {
        for (let i = 0; i < 16; i++){

            let entityProperties = {
                width: blockSize,
                height: blockSize,
                x: Board.chess[i].col * blockSize,
                y: Board.chess[i].row * blockSize,

                type: Board.chess[i].type,
                index:Board.chess[i].ID,
                row: Board.chess[i].row,
                col: Board.chess[i].col,
                isRed: Board.chess[i].isRed,
                turn: Board.chess[i].isRed
            }

            // add chess to game area
            var id = entityManager.createEntityFromUrlWithProperties(
                        Qt.resolvedUrl("../entities/Chess.qml"), entityProperties)
            chesses[i] = entityManager.getEntityById(id)
        }
    }

    function initOther() {
        var block = Qt.createComponent("./Block.qml")
        for(let i=0;i<otherImg.length;++i){
            if(i>otherImg.length-3){
                block.createObject(gameArea,{source:"../../assets/img/Lair.png",
                                       x:otherImg[i][0]*blockSize,
                                       y:otherImg[i][1]*blockSize})
            }else{
                block.createObject(gameArea,{x:otherImg[i][0]*blockSize,y:otherImg[i][1]*blockSize})
            }
        }
    }

    function clearPathes() {
        for(let i=0;i<pathes.length;++i){
            entityManager.removeEntityById(pathes[i].entityId)
        }
        pathes=[]
    }

    function connectBoard() {
        Board.pathesChange.connect(onPathesChange)
        Board.moveChess.connect(onMoveChess)
        Board.statChange.connect(onStatChange)
        Board.turnChange.connect(onTurnChange)
        Board.win.connect(onWin)
        console.log("connect")
    }

    function onPathesChange(size) {
        clearPathes()

        for (let i = 0; i!== size; i++){

            let entityProperties = {
                width: blockSize,
                height: blockSize,
                x: Board.getPath(i).x * blockSize,
                y: Board.getPath(i).y * blockSize,

                col: Board.getPath(i).x,
                row: Board.getPath(i).y ,

            }

            // add block to game area
            var id = entityManager.createEntityFromUrlWithProperties(
                        Qt.resolvedUrl("../entities/Path.qml"), entityProperties)
            pathes[i] = entityManager.getEntityById(id)
        }
        gameArea.pathesChange()
    }
    function onMoveChess(id) {
        chesses[id].x = Board.chess[id].col * blockSize
        chesses[id].y = Board.chess[id].row * blockSize

        chesses[id].row = Board.chess[id].row
        chesses[id].col = Board.chess[id].col

        clearPathes()
    }
    function onStatChange(id) {
//            chesses[id].removeEntity()
        chesses[id].visible = !Board.chess[id].isDead
    }
    function onTurnChange(){
        for(let i=0;i<chesses.length;++i){
            chesses[i].turn = !chesses[i].turn
        }
    }

    function onWin(isRed){
        console.log(isRed," win!")
    }

}
