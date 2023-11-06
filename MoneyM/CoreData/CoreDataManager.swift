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
    func load(_ dateModel: DateModel) -> [TransactionModel]
    func add(_ transaction: TransactionModel, dateModel: DateModel)
    func edit(_ id: Int, _ newTransaction: TransactionModel)
    func delete(_ id: Int)
    func save()
}

class CoreDataManager: CoreDataManagerProtocol {
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func load(_ dateModel: DateModel) -> [TransactionModel] {
        var transactionModelArray: [TransactionModel] = []
        
        let request = FolderEntity.fetchRequest()
        request.predicate = NSPredicate(format: "month == %i AND year == %i", dateModel.month, dateModel.year)
        
        do {
            
            let response = try context.fetch(request)
            
            if let existingFolder = response.first {
                
                for transaction in existingFolder.transactions?.allObjects as! [TransactionEntity] {
                    let newTransaction = TransactionModel()
                    newTransaction.id = Int(transaction.id)
                    newTransaction.amount = Int(transaction.amount)
                    newTransaction.categoryID = Int(transaction.categoryID)
                    newTransaction.date = transaction.date
                    newTransaction.mode = TransactionModel.Mode(rawValue: Int(transaction.mode))

                    transactionModelArray.append(newTransaction)
                }
            }
            
        } catch {
            print ("Error with load data!")
        }
        
        return transactionModelArray
    }
    
    func add(_ transaction: TransactionModel, dateModel: DateModel) {
        var folder: FolderEntity?
        
        let request = FolderEntity.fetchRequest()
        request.predicate = NSPredicate(format: "month == %i AND year == %i", dateModel.month, dateModel.year)
        
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
            folder?.month = Int16(dateModel.month)
            folder?.year = Int16(dateModel.year)
        }
        
        let transactionEntity = TransactionEntity(context: context)
        transactionEntity.id = Int16(transaction.id)
        transactionEntity.categoryID = Int16(transaction.categoryID)
        transactionEntity.amount = Int16(transaction.amount)
        transactionEntity.mode = Int16(transaction.mode.rawValue)
        transactionEntity.date = transaction.date
        
        folder?.addToTransactions(transactionEntity)
        
        save()
    }
    
    func edit(_ id: Int, _ newTransaction: TransactionModel) {
        
        let fetchRequest = TransactionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        
        do {
            let requestedData = try context.fetch(fetchRequest)
            
            let transaction = requestedData.first
            transaction?.amount = Int16(newTransaction.amount)
            transaction?.date = newTransaction.date
            transaction?.categoryID = Int16(newTransaction.categoryID)
            transaction?.mode = Int16(newTransaction.mode.rawValue)
            
        } catch {
            print ("Error with edit transaction!")
        }
        
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
