//
//  ViewController.swift
//  chessgame test1
//
//  Created by yoonoh noh on 10/12/23.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var turnLabel: UILabel!
    
    var chessEngine: ChessEngine = ChessEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardView.chessDelegate = self
        chessEngine.initializeGame()
        boardView.shadowPieces = chessEngine.pieces
        boardView.setNeedsDisplay()
    }
    
    @IBAction func resetButton(_ sender: Any) {
        chessEngine.initializeGame()
        boardView.shadowPieces = chessEngine.pieces
        boardView.setNeedsDisplay()
        turnLabel.text = "Whites"
    }
}

//Importing updatedmoves from other files
extension ViewController: ChessDelegate {
    func movePiece(fromCol: Int8, fromRow: Int8, toCol: Int8, toRow: Int8) {
        updateMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
    }
    func updateMove(fromCol: Int8, fromRow: Int8, toCol: Int8, toRow: Int8){
        chessEngine.movePiece(fromCol: Int(fromCol), fromRow: Int(fromRow), toCol: Int(toCol), toRow: Int(toRow))
        boardView.shadowPieces = chessEngine.pieces
        boardView.setNeedsDisplay()
        
        //updating the label
        if chessEngine.whitesTurn {
            turnLabel.text = "Whites"
        } else {
            turnLabel.text = "Black"
        }
    }
    
    func pieceAt(col: Int8, row: Int8) -> ChessPiece? {
        return chessEngine.pieceAt(col: Int(col), row: Int(row))
    }
}
