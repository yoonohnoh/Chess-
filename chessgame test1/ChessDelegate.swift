//
//  ChessDelegate.swift
//  chessgame test1
//
//  Created by yoonoh noh on 10/24/23.
//

import Foundation

protocol ChessDelegate {
    func movePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int)
    func pieceAt(col: Int, row: Int) -> ChessPiece?
    
}
