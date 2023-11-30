//
//  TransactionEntity+CoreDataProperties.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//
//

import Foundation
import CoreData


extension TransactionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }

    @NSManaged public var amount: Int64
    @NSManaged public var categoryID: Int64
    @NSManaged public var date: Date?
    @NSManaged public var id: Int64
    @NSManaged public var mode: Int64
    @NSManaged public var folder: FolderEntity?

}

extension TransactionEntity : Identifiable {

}
