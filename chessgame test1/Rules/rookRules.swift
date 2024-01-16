//
//  rookRules.swift
//  chessgame test1
//
//  Created by yoonoh noh on 11/11/23.
//

import Foundation

// RookRules.swift
protocol RookRules {
    func isValidMove(from: ChessCoordinate, to: ChessCoordinate) -> Bool
    // Add other rook-specific rules...
}
