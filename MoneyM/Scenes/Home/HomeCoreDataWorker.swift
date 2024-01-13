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
	func saveTransaction(_ transaction: TransactionModel)
	func deleteTransaction(_ id: UUID)
	func editTransaction(_ newTransaction: TransactionModel)
	func save()
}

class HomeCoreDataWorker {
	
	private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
	
	private var concurrencyQueue: DispatchQueue?
	
	init() {
		concurrencyQueue = DispatchQueue.init(label: "com.savikapps.coredata", qos: .background, attributes: .concurrent)
	}
}

// MARK: - HomeCoreDataWorker Logic
extension HomeCoreDataWorker: HomeCoreDataWorkerLogic {
	
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
	
	func saveTransaction(_ transaction: TransactionModel) {
		guard let unwrappedContext = context else { return }
		
		concurrencyQueue?.async {
			
			let newTransactionEntity = TransactionEntity(context: unwrappedContext)
			newTransactionEntity.id = transaction.id
			newTransactionEntity.amount = transaction.amount
			newTransactionEntity.note = transaction.note
			newTransactionEntity.dateOfCreation = transaction.dateOfCreation
			newTransactionEntity.transactionType = Int64(transaction.transactionType.rawValue)
			
			if let unwrappedCategoryID = transaction.categoryID {
				newTransactionEntity.categoryID = Int64(unwrappedCategoryID)
			}
			
			self.save()
			
		}
		
	}
	
	func deleteTransaction(_ id: UUID) {
		guard let unwrappedContext = context else { return }
		
		concurrencyQueue?.async {
			
			let request = TransactionEntity.fetchRequest()
			request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
			
			do {
				
				if let transactionEntity = try unwrappedContext.fetch(request).first {
					unwrappedContext.delete(transactionEntity)
				}
				
			} catch {
				fatalError("\(error)")
			}
			
			self.save()
		}
	}
	
	func editTransaction(_ newTransaction: TransactionModel) {
		guard let unwrappedContext = context else { return }
		
		concurrencyQueue?.async {
			
			let request = TransactionEntity.fetchRequest()
			request.predicate = NSPredicate(format: "id == %@", newTransaction.id as CVarArg)
			
			do {
				
				if let transactionEntity = try unwrappedContext.fetch(request).first {
					transactionEntity.id = newTransaction.id
					transactionEntity.amount = newTransaction.amount
					transactionEntity.note = newTransaction.note
					transactionEntity.dateOfCreation = newTransaction.dateOfCreation
					transactionEntity.transactionType = Int64(newTransaction.transactionType.rawValue)
					
					if let unwrappedCategoryID = newTransaction.categoryID {
						transactionEntity.categoryID = Int64(unwrappedCategoryID)
					}
				}
				
			} catch {
				fatalError("\(error)")
			}
			
			self.save()
		}
		
	}
	
	func save() {
		do {
			try context?.save()
		} catch {
			fatalError("Error with saving data!")
		}
	}
	
}
