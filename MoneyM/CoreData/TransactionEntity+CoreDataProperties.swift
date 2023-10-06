//
//  TransactionEntity+CoreDataProperties.swift
//  MoneyM
//
//  Created by Air on 06.10.2023.
//
//

import Foundation
import CoreData


extension TransactionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }

    @NSManaged public var amount: Int16
    @NSManaged public var categoryID: Int16
    @NSManaged public var date: Date?
    @NSManaged public var id: Int16
    @NSManaged public var mode: Int16
    @NSManaged public var folder: FolderEntity?

}

extension TransactionEntity : Identifiable {

}
