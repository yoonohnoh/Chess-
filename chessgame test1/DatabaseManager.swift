//
//  DatabaseManager.swift
//  chessgame test1
//
//  Created by yoonoh noh on 1/22/24.
//

import Foundation

import SQLite

//taking care of the operations between the database and the chessengine file

struct DatabaseManager {
    static let Instance = DatabaseManager()
    private let db:Connection?
    
    
    private init() {
        let path = DatabaseManager.databasePath()
        do {
            db = try Connection(path)
            print("successfully connected to databases")
        }
        catch {
            db = nil
            print("error to database")
        }
    }
    
    
    static func databasePath() -> String {
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentDirectory.appendingPathComponent("ChessBoard.sqlite3").path
    }

    static func createMovesTable() throws {
        do {
            let db = try Connection(databasePath())
            let movesTable = Table("moves")
            let id = Expression<Int64>("id")
            let fromCol = Expression<Int8>("fromCol")
            let fromRow = Expression<Int8>("fromRow")
            let toCol = Expression<Int8>("toCol")
            let toRow = Expression<Int8>("toRow")

            try db.run(movesTable.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(fromCol)
                table.column(fromRow)
                table.column(toCol)
                table.column(toRow)
            })
        } catch {
            print("Error creating moves table: \(error)")
            throw error
        }
    }

    // Add other database-related methods as needed
}
