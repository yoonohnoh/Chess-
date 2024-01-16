//
//  knightRules.swift
//  chessgame test1
//
//  Created by yoonoh noh on 11/11/23.
//

import Foundation

// KnightRules.swift
protocol KnightRules {
    func isValidMove(from: ChessCoordinate, to: ChessCoordinate) -> Bool
    // Add other knight-specific rules...
}
