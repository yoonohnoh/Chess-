//
//  ChessDelegate.swift
//  chessgame test1
//
//  Created by yoonoh noh on 10/24/23.
//

import Foundation

protocol ChessDelegate {
    func movePiece(fromCol: Int8, fromRow: Int8, toCol: Int8, toRow: Int8)
    func pieceAt(col: Int8, row: Int8) -> ChessPiece?
    
}
