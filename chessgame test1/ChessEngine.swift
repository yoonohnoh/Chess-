//
//  ChessEngine.swift
//  chessgame test1
//
//  Created by yoonoh noh on 10/15/23.
//

import Foundation
import UIKit
import CoreData

struct ChessEngine {
    
    var pieces: Set<ChessPiece> = Set<ChessPiece>()
    var whitesTurn: Bool = true

        
    //pieceAt function
    func pieceAt(col: Int, row: Int) -> ChessPiece? {
            for piece in pieces {
                if col == piece.col && row == piece.row {
                    return piece
                }
            }
            return nil
    }
    
    mutating func movePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) {
            print("movePiece working")
            guard let movingPiece = pieceAt(col: fromCol, row: fromRow) else {
                return
            }

            if movingPiece.isWhite != whitesTurn {
                print("piece is wrong color")
                return
            }

            if !canMovePiece(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow) {
                print("invalid move")
                return
            }
        
// use the target to record the piecetaken
        
            if let target = pieceAt(col: toCol, row: toRow) {
                print("target is runinng")
                // remove the target and save the imagename of the target then later use it to display the taken out pieces on the side
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let chessMove = ChessMove(context: context)
                
                //target's imagename and color
                chessMove.pieceName = String(target.imageName)
                chessMove.white = Bool(target.isWhite)
                
                pieces.remove(target)
            }

            pieces.remove(movingPiece)
            pieces.insert(ChessPiece(col: toCol, row: toRow, imageName: movingPiece.imageName, isWhite: movingPiece.isWhite, rank: movingPiece.rank))

            whitesTurn = !whitesTurn
            saveMoveToCoreData(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        
            
        }

    //function for making changes in the context of the coredata
    mutating func saveMoveToCoreData(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let chessMove = ChessMove(context: context)
            chessMove.fromCol = Int16(fromCol)
            chessMove.fromRow = Int16(fromRow)
            chessMove.toCol = Int16(toCol)
            chessMove.toRow = Int16(toRow)
            chessMove.timestamp = Date()
    
        do {
            try context.save()
            print("Move saved to CoreData")
        } catch {
            print("Error saving move to CoreData: \(error)")
        }
        fetchinglatestdata()
    
    }
    
   //receiving the latest data
    func fetchinglatestdata() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let fetchRequest: NSFetchRequest<ChessMove> = ChessMove.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            fetchRequest.fetchLimit = 1
            
            let moves = try context.fetch(fetchRequest)
            
            // Assuming ChessMove has a description property, replace it with the actual property you want to print
            if let latestMove = moves.first {
                print("Latest Move: From (\(latestMove.fromCol), \(latestMove.fromRow)) to (\(latestMove.toCol), \(latestMove.toRow))")
            } else {
                print("No moves available.")
            }
        } catch {
            print("Error fetching data from CoreData: \(error)")
        }
    }
    
    // undoing the last move
    mutating func undoMove() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            //retrieve the latest data set
            let fetchRequest: NSFetchRequest<ChessMove> = ChessMove.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            fetchRequest.fetchLimit = 1

            let moves = try context.fetch(fetchRequest)
            print("moves", moves.first)

            if let lastMove = moves.first {
                // Undo the move
                guard let movingPiece = pieceAt(col: Int(lastMove.toCol), row: Int(lastMove.toRow)) else{
                    print("Failed to find piece")
                    return
                }
                print("movingpiece", movingPiece.isWhite, movingPiece.imageName)
                pieces.remove(movingPiece)
                pieces.insert(ChessPiece(col: Int(lastMove.fromCol), row: Int(lastMove.fromRow), imageName: movingPiece.imageName, isWhite: movingPiece.isWhite, rank: movingPiece.rank))
                
                whitesTurn = !whitesTurn

                // Remove the undone move from CoreData
                context.delete(lastMove)

                try context.save()
                
                // Refresh UI
            } else {
                print("No moves to undo.")
            }
        } catch {
            print("Error fetching or undoing move from CoreData: \(error)")
        }
    }
    


    func canMovePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
        //checking a piece is inside the boaard
        if toCol<0 || toCol>7 || toRow<0 || toRow>7 {
            return false
        }
        //if not moved, just same place
        if fromCol == toCol && fromRow == toRow {
            return false
        }
        guard let movingPiece = pieceAt(col: fromCol, row: fromRow) else {
            return false
        }
        
        //checking same color
        if let target = pieceAt(col: toCol, row: toRow), target.isWhite == movingPiece.isWhite {
            return false
        }
        
        
        switch movingPiece.rank {
        case .knight:
            return canMoveKnight(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        case .rook:
            return canMoveRook(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        case .bishop:
            return canMoveBishop(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        case .queen:
            return canMoveQueen(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        case .king:
            return canMoveKing(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        case .pawn:
            return canMovePawn(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        }
    }
    
    
    // Rules below
    func canMoveKnight(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
        return abs(fromCol - toCol) == 1 && abs(fromRow - toRow) == 2 ||
        abs(fromRow - toRow) == 1 && (abs(fromCol - toRow) == 2)
    }
    func canMoveRook(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
        guard emptyBetween(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow) else {
            return false
        }
        return fromCol == toCol || fromRow == toRow
    }
    func canMoveBishop(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
        guard emptyBetween(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow) else {
            return false
        }
        return abs(fromCol-toCol) == abs(fromRow-toRow)
    }
    func canMoveQueen(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
        return canMoveRook(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow) ||
        canMoveBishop(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
    }
    func canMoveKing(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
        let deltaCol = abs(fromCol-toCol)
        let deltaRow = abs(fromRow - toRow)
        return (deltaCol == 1 || deltaRow == 1) && deltaCol + deltaRow < 3
    }
    
    func canMovePawn(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
        guard let movingPawn = pieceAt(col: fromCol, row: fromRow) else {
            return false
        }
        // White pawn rules
        if movingPawn.isWhite {
            //diagonal capturing black pawn
            if let piece = pieceAt(col: toCol, row: toRow), !piece.isWhite {
                return toRow == fromRow - 1 && abs(toCol - fromCol) == 1
            }else {
                if fromRow == 6 {
                    //at starting point abale to move 2 blocks at once
                    if pieceAt(col: fromCol, row: 5) == nil && toCol == fromCol {
                        return toRow == 5 || toRow == 4 && pieceAt(col: fromCol, row: 4) == nil
                    }
                }else if fromRow < 6 {
                    // regular move. only 1 block
                    if fromCol == toCol && toRow == fromRow - 1 {
                        return pieceAt(col: fromCol, row: toRow) == nil
                    }
                }
            }
        }else {
            //black pawn move
            if let piece = pieceAt(col: toCol, row: toRow), piece.isWhite {
                return toRow == fromRow + 1 && abs(toCol - fromCol) == 1
            } else {
                //at starting point abale to move 2 blocks at once
                if fromRow == 1 {
                    if pieceAt(col: fromCol, row: 2) == nil && toCol == fromCol {
                        return toRow == 2 || toRow == 3 && pieceAt(col: fromCol, row: 3) == nil
                    }
                }else if fromRow > 1 {
                    if fromCol == toCol && toRow == fromRow + 1 {
                        return pieceAt(col: fromCol, row: toRow) == nil
                    }
                }
            }
        }
        return false
    }
    
    
    
    
    func emptyBetween(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
         if fromRow == toRow { // horizontal movement rook
             let minCol = min(fromCol, toCol)
             let maxCol = max(fromCol, toCol)
             if maxCol - minCol < 2 {
                 return true
             }
             for i in minCol + 1 ... maxCol - 1 {
                 if pieceAt(col: i, row: fromRow) != nil {
                     return false
                 }
             }
             return true
             
         }else if fromCol == toCol { // vertical movement rook
             let minRow = min(fromRow, toRow)
             let maxRow = max(fromRow, toRow)
             if maxRow - minRow < 2 {
                 return true
             }
             for i in minRow + 1 ... maxRow - 1 {
                 if pieceAt(col: fromCol, row: i) != nil {
                     return false
                 }
             }
             return true
             
         }else if abs(fromCol-toCol) == abs(fromRow-toRow) { // diagonal movement bishop
             if fromRow - toRow == toCol - fromCol {
                 let minCol = min(fromCol, toCol)
                 let maxCol = max(fromCol, toCol)
                 let minRow = min(fromRow, toRow)
                 let maxRow = max(fromRow, toRow)
                 
                 if fromCol - toCol == fromRow - toRow { //top left to bottom right
                     if maxCol - minCol < 2 {
                         return true
                     }
                     for i in 0..<abs(fromCol - toCol){
                         if pieceAt(col: minCol+i , row: fromRow+i) != nil {
                             return false
                         }
                     }
                     return true
                     
                 }else { //bottom left to top right
                     if maxCol - minCol < 2 {
                         return true
                     }
                     for i in 1..<abs(fromCol - toCol) {
                         if pieceAt(col: minCol+i, row: maxRow-i) != nil {
                             return false
                         }
                     }
                     return true
                 }
             }
         }
         return false
     }
    
    mutating func initializeGame() {
        
        whitesTurn = true
        pieces.removeAll()
        
        /* loop for rook, knight, bishop*/
        for i in 0..<2 {
            pieces.insert(ChessPiece(col: i*7, row: 0,   imageName: "b_rook",  isWhite: false, rank: .rook))
            pieces.insert(ChessPiece(col: i*7, row: 7,   imageName: "w_rook",  isWhite: true, rank: .rook))
            pieces.insert(ChessPiece(col: 1+i*5, row: 0, imageName: "b_knight",isWhite: false, rank: .knight))
            pieces.insert(ChessPiece(col: 1+i*5, row: 7, imageName: "w_knight",isWhite: true, rank: .knight))
            pieces.insert(ChessPiece(col: 2+i*3, row: 0, imageName: "b_bishop",isWhite: false, rank: .bishop))
            pieces.insert(ChessPiece(col: 2+i*3, row: 7, imageName: "w_bishop",isWhite: true, rank: .bishop))
        }
        
        
        pieces.insert(ChessPiece(col: 3, row: 0, imageName:"b_queen", isWhite: false, rank: .queen))
        pieces.insert(ChessPiece(col: 3, row:7,  imageName:"w_queen", isWhite: true, rank: .queen))
        pieces.insert(ChessPiece(col: 4, row: 0, imageName: "b_king", isWhite: false, rank: .king))
        pieces.insert(ChessPiece(col: 4, row: 7, imageName: "w_king", isWhite: true, rank: .king))
        
        /* loop for pawns */
        for col in 0..<8 {
            pieces.insert(ChessPiece(col: col, row: 1, imageName: "b_pawn", isWhite: false, rank: .pawn))
            pieces.insert(ChessPiece(col: col, row: 6, imageName: "w_pawn", isWhite: true, rank: .pawn))
        }
        
    }
}
