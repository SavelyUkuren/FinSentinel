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
    func load(_ components: DateComponents) -> [TransactionEntity]
    func add(_ transactionModel: TransactionModel)
    func edit(_ id: Int, _ newTransaction: TransactionModel)
    func delete(_ id: Int)
    func save()
}

class CoreDataManager: CoreDataManagerProtocol {
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func load(_ components: DateComponents) -> [TransactionEntity] {
        var transactionsArray: [TransactionEntity] = []
        
        let request = FolderEntity.fetchRequest()
        request.predicate = NSPredicate(format: "month == %i AND year == %i", components.month!, components.year!)
		
        do {
            
            let response = try context.fetch(request)
            
            if let existingFolder = response.first {
				transactionsArray = existingFolder.transactions?.allObjects as! [TransactionEntity]
            }
            
        } catch {
            print ("Error with load data!")
        }
        
        return transactionsArray
    }
    
    func add(_ transactionModel: TransactionModel) {
        var folder: FolderEntity?
		
		var components = Calendar.current.dateComponents([.month, .year], from: transactionModel.date!)
		let month: Int = components.month ?? 1
		let year: Int = components.year ?? 2000
        
        let request = FolderEntity.fetchRequest()
        request.predicate = NSPredicate(format: "month == %i AND year == %i", month, year)
        
        do {
            let response = try context.fetch(request)
            
            if let existingFolder = response.first {
                folder = existingFolder
            }
            
        } catch {
            print("Error with find folder!")
        }
        
        if folder == nil {
            folder = FolderEntity(context: context)
            folder?.month = Int16(month)
            folder?.year = Int16(year)
        }
        
        let transactionEntity = TransactionEntity(context: context)
		transactionEntity.id = Int64(transactionModel.id)
		transactionEntity.categoryID = Int64(transactionModel.categoryID ?? 0)
        transactionEntity.amount = Int64(transactionModel.amount ?? 0)
		transactionEntity.mode = Int64(transactionModel.mode?.rawValue ?? 0)
        transactionEntity.date = transactionModel.date
        
        folder?.addToTransactions(transactionEntity)
        
        save()
    }
    
    func edit(_ id: Int, _ newTransaction: TransactionModel) {
        
//        let fetchRequest = TransactionEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
//        
//        do {
//            let requestedData = try context.fetch(fetchRequest)
//            
//            let transaction = requestedData.first
//            transaction?.amount = Int16(newTransaction.amount)
//            transaction?.date = newTransaction.date
//            transaction?.categoryID = Int16(newTransaction.categoryID)
//            transaction?.mode = Int16(newTransaction.mode.rawValue)
//            
//        } catch {
//            print ("Error with edit transaction!")
//        }
        
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
    
}
