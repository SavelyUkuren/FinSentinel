//
//  TransactionEntity+CoreDataProperties.swift
//  MoneyM
//
//  Created by Air on 16.09.2023.
//
//

import Foundation
import CoreData


extension TransactionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }

    @NSManaged public var amount: Int16
    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: Int16
    @NSManaged public var mode: Int16

}

extension TransactionEntity : Identifiable {

}
