//
//  chessgame_test1Tests.swift
//  chessgame test1Tests
//
//  Created by yoonoh noh on 10/12/23.
//

import XCTest
@testable import GT_Chess

class ChessEngineTests: XCTestCase {
    func testPrintiingEmptyGameboard() {
        let game = ChessEngine()
        
        print(game)
    }
}
