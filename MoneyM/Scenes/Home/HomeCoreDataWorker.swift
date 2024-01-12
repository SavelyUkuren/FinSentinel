//
//  HomeCoreDataWorker.swift
//  MoneyM
//
//  Created by savik on 12.01.2024.
//

import Foundation
import CoreData
import UIKit

protocol HomeCoreDataWorkerLogic {
	func loadTransactions(from: Date, to: Date) -> [TransactionModel]
}

class HomeCoreDataWorker {
	
	private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
	
}

// MARK: - HomeCoreDataWorker Logic
extension HomeCoreDataWorker: HomeCoreDataWorkerLogic {
	
	func loadTransactions(from: Date, to: Date) -> [TransactionModel] {
		guard let unwrappedContext = context else { return [] }
		
		var transactions: [TransactionModel] = []
		
		let request = TransactionEntity.fetchRequest()
		request.predicate = NSPredicate(format: "dateOfCreation > %@ AND dateOfCreation < %@", from as CVarArg, to as CVarArg)
		
		do {
			
			let response = try context?.fetch(request)
			transactions = response!.map({ transactionEntity in
				
				var model = TransactionModel()
				model.id = transactionEntity.id
				model.amount = transactionEntity.amount
				
				return model
			})
			print ("A")
		} catch {
			fatalError("\(error)")
		}
		
		return []
	}
	
}
