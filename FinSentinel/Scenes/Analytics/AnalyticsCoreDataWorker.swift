//
//  AnalyticsCoreDataWorker.swift
//  MoneyM
//
//  Created by savik on 13.01.2024.
//

import Foundation
import UIKit

protocol AnalyticsCoreDataWorkerLogic {
	func loadTransactions(from: Date, to: Date) -> [TransactionModel]
	func loadAll() -> [TransactionModel]
}

class AnalyticsCoreDataWorker: AnalyticsCoreDataWorkerLogic {
	
	private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
	
	private var concurrencyQueue: DispatchQueue?
	
	init() {
		concurrencyQueue = DispatchQueue(label: "com.savikapps.analytics", qos: .background, attributes: .concurrent)
	}
	
	func loadTransactions(from: Date, to: Date) -> [TransactionModel] {
		var transactions: [TransactionModel] = []
		
		let request = TransactionEntity.fetchRequest()
		request.predicate = NSPredicate(format: "dateOfCreation > %@ AND dateOfCreation < %@", from as CVarArg, to as CVarArg)
		
		do {
			
			let response = try context?.fetch(request)
			transactions = response!.map({ transactionEntity in
				
				var model = TransactionModel()
				model.id = transactionEntity.id
				model.amount = transactionEntity.amount
				model.dateOfCreation = transactionEntity.dateOfCreation
				model.categoryID = Int(transactionEntity.categoryID)
				model.transactionType = TransactionType(rawValue: Int(transactionEntity.transactionType)) ?? .expense
				model.note = transactionEntity.note
				
				return model
			})
			
		} catch {
			fatalError("\(error)")
		}
		
		return transactions
	}
	
	func loadAll() -> [TransactionModel] {
		var transactions: [TransactionModel] = []
		
		let request = TransactionEntity.fetchRequest()
		
		do {
			
			let response = try context?.fetch(request)
			transactions = response!.map({ transactionEntity in
				
				var model = TransactionModel()
				model.id = transactionEntity.id
				model.amount = transactionEntity.amount
				model.dateOfCreation = transactionEntity.dateOfCreation
				model.categoryID = Int(transactionEntity.categoryID)
				model.transactionType = TransactionType(rawValue: Int(transactionEntity.transactionType)) ?? .expense
				model.note = transactionEntity.note
				
				return model
			})
			
		} catch {
			fatalError("\(error)")
		}
		
		return transactions
	}
	
}
