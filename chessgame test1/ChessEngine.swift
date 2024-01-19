//
//  ChessEngine.swift
//  chessgame test1
//
//  Created by yoonoh noh on 10/15/23.
//

import Foundation
import SQLite3

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
        //
        
        if !canMovePiece(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow) {
            return
        }
        
        guard let movingPiece = pieceAt(col: fromCol, row: fromRow) else {
            return
        }
        
        
        if let target = pieceAt(col: toCol, row: toRow) {
            pieces.remove(target)
        }
        // check if move is valid canMovePiece
        
        pieces.remove(movingPiece)
        pieces.insert(ChessPiece(col: toCol, row: toRow, imageName: movingPiece.imageName, isWhite: movingPiece.isWhite, rank: movingPiece.rank))
        
        whitesTurn = !whitesTurn
        
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
        if movingPiece.isWhite != whitesTurn{
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
//
////DataBase
//let db = try Connection(dbPath)
//let moves = Table("moves")
//
//try db.run(moves.create(ifNotExists: true) { table in
//    table.column(Expression<Int>("id"), primaryKey: .autoincrement)
//    table.column(Expression<String>("move"))
//    // Add other columns as needed
//})
//let move = "e2e4" // Replace this with the actual move data
//try db.run(moves.insert(Expression<String>("move") <- move))
//
//try db.run(moves.create(ifNotExists: true) { table in
//    table.column(moveID, primaryKey: .autoincrement)
//    table.column(fromCol)
//    table.column(fromRow)
//    table.column(toCol)
//    table.column(toRow)
//    table.column(timestamp)
//    // Add other columns as needed
//})
//let moveData = (fromCol: 1, fromRow: 2, toCol: 3, toRow: 4, timestamp: Date().timeIntervalSince1970)
//try db.run(moves.insert(
//    fromCol <- moveData.fromCol,
//    fromRow <- moveData.fromRow,
//    toCol <- moveData.toCol,
//    toRow <- moveData.toRow,
//    timestamp <- moveData.timestamp
//))
//let db = try Connection("/path/to/your/database.sqlite3")

    
    
    
    
    
    
    
