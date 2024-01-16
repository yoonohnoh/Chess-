//
//  ChessPiece.swift
//  chessgame test1
//
//  Created by yoonoh noh on 10/15/23.
//

import Foundation

struct ChessPiece : Hashable {
    let col: Int
    let row: Int
    let imageName: String
    let isWhite: Bool // true for white and false for black
    let rank: ChessRank
}

