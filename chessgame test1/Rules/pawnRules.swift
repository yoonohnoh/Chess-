//
//  pawnRules.swift
//  chessgame test1
//
//  Created by yoonoh noh on 11/11/23.
//
import Foundation

struct PawnRules {
    static func canMovePawn(to destination: ChessPiece, from origin: ChessPiece) -> Bool {
        let direction = origin.isWhite ? 1 : -1
        let forwardOne = origin.row + direction
        let forwardTwo = origin.row + 2 * direction

        // Pawns can move forward one square
        if destination.col == origin.col && destination.row == forwardOne {
            return true
        }

        // Pawns can move forward two squares on their first move
        if !origin.hasMoved && destination.row == forwardTwo {
            return true
        }

        return false
    }

    static func canCapturePawn(at target: ChessPiece, from origin: ChessPiece) -> Bool {
        let direction = origin.isWhite ? 1 : -1
        let forwardOne = origin.row + direction
        let leftDiagonal = origin.col - 1
        let rightDiagonal = origin.col + 1

        // Pawns can capture diagonally
        if target.row == forwardOne && (target.col == leftDiagonal || target.col == rightDiagonal) {
            return true
        }

        return false
    }
}
