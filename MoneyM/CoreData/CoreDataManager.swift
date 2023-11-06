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
    
    
}
