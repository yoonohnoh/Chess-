//
//  knightMove.swift
//  chessgame test1
//
//  Created by yoonoh noh on 11/10/23.
//

import Foundation

struct knight: ChessPiece {
    var col: Int
    var row: Int
    var imageName: String
    var isWhite: Bool
    
    init(x : Int, y : Int) {
        col = x ; row = y
        imageName = 
    }

    func movePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) {
        print("knight works")
    }

    func pieceAt(col: Int, row: Int) -> ChessPiece? {
        print("kinght works")
        return nil
    }
}
