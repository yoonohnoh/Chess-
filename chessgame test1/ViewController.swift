//
//  ViewController.swift
//  chessgame test1
//
//  Created by yoonoh noh on 10/12/23.
//

import UIKit
import CoreData

class ViewController: UIViewController{
    
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var turnLabel: UILabel!
    
    @IBOutlet weak var blackPieces: UIImageView!
    @IBOutlet weak var whitePieces: UIImageView!
    
    //array for fetching data
    var takenPieces : [ChessMove] = []
    
    var chessEngine: ChessEngine = ChessEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch taken pieces from Core Data
        fetchTakenPieces()
        // Update views with fetched taken pieces
        updateViews()
        
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

    @IBAction func undoButton(_ sender: Any) {
        chessEngine.undoMove()
        boardView.shadowPieces = chessEngine.pieces
        boardView.setNeedsDisplay()

        // Update the turn label
        if chessEngine.whitesTurn {
            turnLabel.text = "Whites"
        } else {
            turnLabel.text = "Black"
        }
    }
    //call the function where needed
    // undo when you take a piece
    //differentiate taken out and to..
    func fetchTakenPieces() {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<ChessMove> = ChessMove.fetchRequest()
            do {
                takenPieces = try context.fetch(fetchRequest)
            } catch {
                print("Error fetching taken pieces: \(error)")
            }
        }

    func updateViews() {
        for takenPiece in takenPieces {
            if let imageName = takenPiece.pieceName {
                if let image = UIImage(named: imageName) {
                    if takenPiece.white {
                        whitePieces.image = image
                    } else {
                        blackPieces.image = image
                    }
                } else {
                    print("Image not found for piece: \(imageName)")
                }
            }
        }
    }
}


//Importing updatedmoves from other files
extension ViewController: ChessDelegate {
    
    func movePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) {
        updateMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
    }
    
    func updateMove(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int){
        chessEngine.movePiece(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        //update the boardview
        boardView.shadowPieces = chessEngine.pieces
        boardView.setNeedsDisplay()
        
        //updating the label
        if chessEngine.whitesTurn {
            turnLabel.text = "Whites"
        } else {
            turnLabel.text = "Black"
        }
    }
    
    func pieceAt(col: Int, row: Int) -> ChessPiece? {
        return chessEngine.pieceAt(col: col, row: row)
    }
}
