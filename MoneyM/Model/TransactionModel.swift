//
//  TransactionModel.swift
//  MoneyM
//
//  Created by Air on 03.09.2023.
//

import Foundation
import UIKit


class TransactionModel {
    
    enum Mode: Int {
        case Expense, Income
    }
    var id: Int!
    var date: Date!
    var amount: String!
    var mode: Mode!
    var category: CategoryModel!
    
}

class TransactionsStatistics {
    var balance: Int = 0
    var amountOfExpense: Int = 0
    var amountOfIncome: Int = 0
    
    public func resetToZero() {
        balance = 0
        amountOfIncome = 0
        amountOfExpense = 0
    }
}

class TransactionModelManager {
    
    class TableViewData {
        var section: DateComponents!
        var transactions: [TransactionModel]!
    }
    
    public var data: [TableViewData] = []
    
    public var statistics: TransactionsStatistics!
    
    public var startingBalance: Int = 0
    
    private var allTransactions: [TransactionModel] = []
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var categories: Categories!
    
    init() {
        categories = Categories()
        statistics = TransactionsStatistics()
        
        //loadData()
        data = groupingTransactionsByDate()
        calculateStatistics()
    }
    
    public func calculateStatistics() {
        
        statistics.resetToZero()
        
        for transaction in allTransactions {
            if transaction.mode == .Expense {
                statistics.amountOfExpense += Int(transaction.amount) ?? 0
            } else if transaction.mode == .Income {
                statistics.amountOfIncome += Int(transaction.amount) ?? 0
            }
        }
        
        statistics.balance = startingBalance + (statistics.amountOfIncome - statistics.amountOfExpense)
        
    }
    
    public func removeTransaction(indexPath: IndexPath) {
        let removedTransaction = data[indexPath.section].transactions.remove(at: indexPath.row)
        
        // Remove from allTransactions array
        let indexInAllTransactions = allTransactions.firstIndex { removedTransaction.id == $0.id }
        allTransactions.remove(at: indexInAllTransactions!)
        
        // Remove from CoreData
        let fetchRequest = TransactionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", removedTransaction.id)
        
        do {
            let requestedData = try context.fetch(fetchRequest)
            context.delete(requestedData.first!)
        } catch {
            fatalError("Error with removing transaction from CoreData")
        }
        
        saveData()
    }
    
    public func addTransaction(transaction: TransactionModel, dateModel: DateModel) {
        transaction.id = allTransactions.count
        
        data.removeAll()
        allTransactions.append(transaction)
        
        data = groupingTransactionsByDate()
        
        addTransactionToCoreData(transaction: transaction, dateModel: dateModel)
        
        saveData()
        calculateStatistics()
    }
    
    public func editTransactionByID(id: Int, newTransaction: TransactionModel) {
        let foundTransactionIndex = allTransactions.firstIndex { $0.id == id }!
        
        allTransactions[foundTransactionIndex].amount = newTransaction.amount
        allTransactions[foundTransactionIndex].mode = newTransaction.mode
        allTransactions[foundTransactionIndex].category = newTransaction.category
        allTransactions[foundTransactionIndex].date = newTransaction.date
        
        calculateStatistics()
        data = groupingTransactionsByDate()
        
        // Edit transaction in CoreData
        let fetchRequest = TransactionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", allTransactions[foundTransactionIndex].id)
        
        do {
            let requestedData = try context.fetch(fetchRequest)
            
            let transaction = requestedData.first
            transaction?.amount = Int16(newTransaction.amount)!
            transaction?.date = newTransaction.date
            transaction?.categoryID = Int16(newTransaction.category.id)
            transaction?.mode = Int16(newTransaction.mode.rawValue)
            
            saveData()
            
        } catch {
            fatalError("Error with edit transaction")
        }
        
    }
    
    private func groupingTransactionsByDate() -> [TableViewData] {
        var arr: [TableViewData] = []
        
        let groupedTransactions = Dictionary(grouping: allTransactions) {
            let date = Calendar.current.dateComponents([.year, .month, .day], from: $0.date)
            return date
        }
        
        for (key, value) in groupedTransactions {
            let temp = TableViewData()
            temp.section = key
            temp.transactions = value
            arr.append(temp)
        }
        
        arr = arr.sorted(by: { $0.section.day! < $1.section.day! })
        
        return arr
    }
    
    public func loadData(dateModel: DateModel) {
        
        allTransactions.removeAll()
        data.removeAll()
        
        let request = FolderEntity.fetchRequest()
        request.predicate = NSPredicate(format: "month == %i AND year == %i", dateModel.month, dateModel.year)
        
        do {
            
            let response = try context.fetch(request)
            
            if let existingFolder = response.first {
                
                for transaction in existingFolder.transactions?.allObjects as! [TransactionEntity] {
                    let newTransaction = TransactionModel()
                    newTransaction.id = Int(transaction.id)
                    newTransaction.amount = "\(transaction.amount)"
                    newTransaction.category = categories.findCategoryByID(id: Int(transaction.categoryID))
                    newTransaction.date = transaction.date
                    newTransaction.mode = TransactionModel.Mode(rawValue: Int(transaction.mode))

                    allTransactions.append(newTransaction)
                }
            }
            
        } catch {
            fatalError("Error with load data")
        }
        
        data = groupingTransactionsByDate()
        calculateStatistics()
        
    }
    
    private func saveData() {
        do {
            try context.save()
        } catch {
            fatalError("Error with saving data")
        }
    }
    
    private func addTransactionToCoreData(transaction: TransactionModel, dateModel: DateModel) {
        
        var folder: FolderEntity?
        
        let request = FolderEntity.fetchRequest()
        request.predicate = NSPredicate(format: "month == %i AND year == %i", dateModel.month, dateModel.year)
        
        do {
            let response = try context.fetch(request)
            
            if let existingFolder = response.first {
                folder = existingFolder
            }
            
        } catch {
            fatalError("Error with find folder")
        }
        
        if folder == nil {
            folder = FolderEntity(context: context)
            folder?.month = Int16(dateModel.month)
            folder?.year = Int16(dateModel.year)
        }
        
        let transactionEntity = TransactionEntity(context: context)
        transactionEntity.id = Int16(transaction.id)
        transactionEntity.categoryID = Int16(transaction.category.id)
        transactionEntity.amount = Int16(transaction.amount) ?? 0
        transactionEntity.mode = Int16(transaction.mode.rawValue)
        transactionEntity.date = transaction.date
        
        folder?.addToTransactions(transactionEntity)
    }
    
}
