//
//  TransactionEntityV1ToV1_3.swift
//  MoneyM
//
//  Created by savik on 12.01.2024.
//

import Foundation
import CoreData

final class TransactionEntityV1ToV1_3: NSEntityMigrationPolicy {
	
	override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
		try super.createDestinationInstances(forSource: sInstance, in: mapping, manager: manager)
		
		guard let destination = manager.destinationInstances(forEntityMappingName: mapping.name,
															 sourceInstances: [sInstance]).first
		else {
			fatalError("Error with getting destination entity!")
		}
		
		guard let sourceAmount = sInstance.value(forKey: "amount") as? NSNumber else {
			fatalError("Error with getting 'amount' value!")
		}
		
		let doubleAmount = Double(truncating: sourceAmount)
		let newAmount = NSNumber(value: doubleAmount)
		
		destination.setValue(newAmount, forKey: "amount")
	}
	
}
