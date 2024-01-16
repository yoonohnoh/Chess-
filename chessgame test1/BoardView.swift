//
//  BoardView.swift
//  chessgame test1
//
//  Created by yoonoh noh on 10/12/23.
//

import UIKit

class BoardView: UIView {
    
    let ratio : CGFloat = 0.8
    var originX: CGFloat = 30
    var originY: CGFloat = 30
    var cellside: CGFloat = 39
    
    var shadowPieces: Set<ChessPiece> = Set<ChessPiece>()
    var chessDelegate: ChessDelegate? = nil
    
    var fromCol: Int? = nil
    var fromRow: Int? = nil
    
    var movingImage: UIImage? = nil
    var movingPieceX: CGFloat = -10000
    var movingPieceY: CGFloat = -10000
    
    
    
    override func draw(_ rect: CGRect) {
        cellside = bounds.width * ratio / 8
        originX = bounds.width * (1-ratio) / 2
        originY = bounds.height * (1-ratio) / 2
        
        drawBoard()
        putPieces()
        
        drawRanksAndFiles()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let first = touches.first!
        let location = first.location(in: self)
        fromCol = Int((location.x - originX) / cellside)
        fromRow = Int((location.y - originY) / cellside)
        
        if let fromCol = fromCol, let fromRow = fromRow, let movingPiece =  chessDelegate?.pieceAt(col: fromCol, row: fromRow) {
            movingImage = UIImage(named: movingPiece.imageName)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let first = touches.first!
        let location = first.location(in: self)
        movingPieceX = location.x
        movingPieceY = location.y
        setNeedsDisplay()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let first = touches.first!
        let location = first.location(in: self)
        
        let toCol: Int = Int((location.x - originX) / cellside)
        let toRow: Int = Int((location.y - originY) / cellside)
        
        if let fromCol = fromCol, let fromRow = fromRow, fromCol != toCol || fromRow != toRow {
            chessDelegate?.movePiece(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        }
        
        movingImage = nil
        fromCol = nil
        fromRow = nil
        setNeedsDisplay()
    }

    
    func putPieces() {
        for p in shadowPieces {
            if fromCol == p.col && fromRow == p.row {
                continue
            }
            let pieceImage = UIImage(named: p.imageName)
            pieceImage?.draw(in: CGRect(x: originX + CGFloat(p.col)*cellside, y: originY + CGFloat(p.row)*cellside, width: cellside, height: cellside))
        }
        movingImage?.draw(in: CGRect(x: movingPieceX - cellside/2, y: movingPieceY - cellside/2, width: cellside, height: cellside))
    }
    
    func drawSquare(col: Int, row: Int, color: UIColor) {
        let path = UIBezierPath(rect: CGRect(x: originX + CGFloat(col) * cellside,
                    y: originY + CGFloat(row) * cellside
                    , width: cellside, height: cellside))
        color.setFill()
        path.fill()
    }
    
    func drawBoard() {
        for row in 0..<4 {
            
            for col in 0..<4 {
                drawSquare(col: col * 2, row: row * 2, color: UIColor.white)
                drawSquare(col: 1 + col * 2, row: row * 2, color: UIColor.brown)
                drawSquare(col: col * 2, row: 1 + row * 2, color: UIColor.brown)
                drawSquare(col: 1 + col * 2, row: 1 + row * 2, color: UIColor.white)
            }
        }
    }
    
    func drawRanksAndFiles() {
            let ranks = ["8", "7", "6", "5", "4", "3", "2", "1"]
            let files = ["a", "b", "c", "d", "e", "f", "g", "h"]

            for i in 0..<8 {
                // Draw ranks (numbers) on the left side
                let rankLabel = UILabel(frame: CGRect(x: 5, y: originY + CGFloat(i) * cellside + 5, width: 20, height: cellside - 10))
                rankLabel.text = ranks[i]
                rankLabel.textAlignment = .center
                addSubview(rankLabel)

                // Draw files (letters) on the bottom
                let fileLabel = UILabel(frame: CGRect(x: originX + CGFloat(i) * cellside + 5, y: frame.height - 25, width: cellside - 10, height: 20))
                fileLabel.text = files[i]
                fileLabel.textAlignment = .center
                addSubview(fileLabel)
            }
        }
    
}
