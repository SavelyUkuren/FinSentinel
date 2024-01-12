//
//  TransactionEntity+CoreDataProperties.swift
//  MoneyM
//
//  Created by savik on 12.01.2024.
//
//

import Foundation
import CoreData


extension TransactionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }

    @NSManaged public var amount: Double
    @NSManaged public var categoryID: Int64
    @NSManaged public var dateOfCreation: Date
    @NSManaged public var id: UUID
    @NSManaged public var transactionType: Int64
    @NSManaged public var note: String?
//    @NSManaged public var folder: FolderEntity?

}

extension TransactionEntity : Identifiable {

}
