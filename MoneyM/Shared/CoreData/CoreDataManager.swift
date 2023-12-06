//
//  CoreDataManager.swift
//  MoneyM
//
//  Created by Air on 06.11.2023.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataManagerProtocol {
	func load(year: Int, month: Int) -> [TransactionModel]
    func add(_ transactionModel: TransactionModel)
    func edit(_ id: Int, _ newTransaction: TransactionModel)
    func delete(_ id: Int)
    func save()
}

class CoreDataManager: CoreDataManagerProtocol {
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func load(year: Int, month: Int) -> [TransactionModel] {
        var transactionsArray: [TransactionModel] = []
        
		let folder = getFolderBy(year: year, month: month)
		
		if let unwrapFolder = folder {
			
			let transactionEntities = unwrapFolder.transactions?.allObjects as! [TransactionEntity]
			for entity in transactionEntities {
				let model = convertEntityToTransaction(entity)
				transactionsArray.append(model)
			}
			
		}
        
        return transactionsArray
    }
    
    func add(_ transactionModel: TransactionModel) {
        var folder: FolderEntity?
		
		let components = getComponentsFrom(transactionModel.date, components: [.year, .month])
		let year = components.year!
		let month = components.month!
		
		folder = getFolderBy(year: year, month: month)
		
		if folder == nil {
			folder = createFolder(year, month, context)
		}
		
		let transactionEntity = convertTransactionToEntity(transactionModel, context: context)
		folder?.addToTransactions(transactionEntity)
        
        save()
    }
    
    func edit(_ id: Int, _ newTransaction: TransactionModel) {
        
        save()
    }
    
    func delete(_ id: Int) {
        
        let fetchRequest = TransactionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        
        do {
            let requestedData = try context.fetch(fetchRequest)
            context.delete(requestedData.first!)
        } catch {
            fatalError("Error with removing transaction from CoreData")
        }
        
        save()
    }
    
    public func save() {
        do {
            try context.save()
        } catch {
            print("Error with saving data!")
        }
    }
    
	private func getComponentsFrom(_ date: Date, components: Set<Calendar.Component>) -> DateComponents {
		let calendar = Calendar.current
		let component = calendar.dateComponents(components, from: date)
		return component
	}
	
	private func getFolderBy(year: Int, month: Int) -> FolderEntity? {
		let request = FolderEntity.fetchRequest()
		request.predicate = NSPredicate(format: "year == %i && month == %i", year, month)
		
		do {
			
			let response = try context.fetch(request)
			
			return response.first
			
		} catch {
			print ("Error! Folder is not found!")
		}
		
		return nil
	}
	
	private func createFolder(_ year: Int, _ month: Int, _ context: NSManagedObjectContext) -> FolderEntity {
		let folder = FolderEntity(context: context)
		folder.month = Int16(month)
		folder.year = Int16(year)
		return folder
	}
	
	private func convertTransactionToEntity(_ transaction: TransactionModel, context: NSManagedObjectContext) -> TransactionEntity {
		let entity = TransactionEntity(context: context)
		
		entity.id = Int64(transaction.id)
		entity.amount = Int64(transaction.amount)
		entity.categoryID = Int64(transaction.categoryID ?? 0)
		entity.date = transaction.date
		entity.mode = Int64(transaction.mode.rawValue)
		entity.note = transaction.note
		
		return entity
	}
	
	private func convertEntityToTransaction(_ transaction: TransactionEntity) -> TransactionModel {
		let model = TransactionModel()
		
		model.id = Int(transaction.id)
		model.amount = Int(transaction.amount)
		model.categoryID = Int(transaction.categoryID)
		model.date = transaction.date
		model.mode = TransactionModel.Mode(rawValue: Int(transaction.mode))
		model.note = transaction.note
		
		return model
	}
	
}
