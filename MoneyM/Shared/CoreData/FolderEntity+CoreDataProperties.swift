//
//  FolderEntity+CoreDataProperties.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//
//

import Foundation
import CoreData


extension FolderEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FolderEntity> {
        return NSFetchRequest<FolderEntity>(entityName: "FolderEntity")
    }

    @NSManaged public var month: Int16
    @NSManaged public var year: Int16
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for transactions
extension FolderEntity {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: TransactionEntity)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: TransactionEntity)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension FolderEntity : Identifiable {

}
