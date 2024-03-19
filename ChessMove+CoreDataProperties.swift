//
//  ChessMove+CoreDataProperties.swift
//  chessgame test1
//
//  Created by yoonoh noh on 2/13/24.
//
//

import Foundation
import CoreData


extension ChessMove {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChessMove> {
        return NSFetchRequest<ChessMove>(entityName: "ChessMove")
    }

    @NSManaged public var fromCol: Int16
    @NSManaged public var fromRow: Int16
    @NSManaged public var toRow: Int16
    @NSManaged public var toCol: Int16

}

extension ChessMove : Identifiable {

}
