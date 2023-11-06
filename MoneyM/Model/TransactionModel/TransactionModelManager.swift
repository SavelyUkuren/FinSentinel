//
//  TransactionModelManager.swift
//  MoneyM
//
//  Created by Air on 01.11.2023.
//

import Foundation
import UIKit

class TransactionModelManager {
    
    class TableViewData {
        var section: DateComponents!
        var transactions: [TransactionModel]!
    }
    
    public var data: [TableViewData] = []
    
    public var financialSummary: FinancialSummary!
    
    public var startingBalance: Int = 0
    
    private var transactionCollection: TransactionCollectionProtocol!
    
    private var coreDataManager: CoreDataManagerProtocol!
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var categories: Categories!
    
    init() {
        categories = Categories()
        financialSummary = FinancialSummary()
        transactionCollection = TransactionCollection()
        coreDataManager = CoreDataManager()
        
        data = groupingTransactionsByDate()
    }
    
    public func removeTransaction(indexPath: IndexPath) {
        let removedTransaction = data[indexPath.section].transactions.remove(at: indexPath.row)
        
        // Remove from allTransactions
        transactionCollection.delete(removedTransaction.id)
        
        // Remove from CoreData
        let fetchRequest = TransactionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", removedTransaction.id)
        
        do {
            let requestedData = try context.fetch(fetchRequest)
            context.delete(requestedData.first!)
        } catch {
            fatalError("Error with removing transaction from CoreData")
        }
        
        // We change the sign so that the calculations are reversed.
        // For example, when removed, income didn't increase, but decreased
        removedTransaction.amount *= -1
        calculateSummary(transaction: removedTransaction, summary: financialSummary)
    }
    
    public func addTransaction(transaction: TransactionModel, dateModel: DateModel) {
        data.removeAll()
        transactionCollection.append(transaction)
        calculateSummary(transaction: transaction, summary: financialSummary)
        
        data = groupingTransactionsByDate()
        
        coreDataManager.add(transaction, dateModel: dateModel)
        
    }
    
    public func editTransactionByID(id: Int, newTransaction: TransactionModel) {
        
        transactionCollection.edit(id, newTransaction: newTransaction)
        
        data = groupingTransactionsByDate()
        
        // Edit transaction in CoreData
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
            fatalError("Error with edit transaction")
        }
        
        calculateSummary(transaction: newTransaction, summary: financialSummary)
    }
    
    private func groupingTransactionsByDate() -> [TableViewData] {
        var arr: [TableViewData] = []
        
        let groupedTransactions = Dictionary(grouping: Array(transactionCollection.getValues())) {
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
        transactionCollection.removeAll()
        data.removeAll()
        
        let transactions = coreDataManager.load(dateModel)
        transactions.forEach { transaction in
            transactionCollection.append(transaction)
        }
        
        data = groupingTransactionsByDate()
        financialSummary = calculateAllTransactions()
    }
    
    private func calculateAllTransactions() -> FinancialSummary {
        
        let result = FinancialSummary()
        
        for key in transactionCollection.getKeys() {
            let transaction = transactionCollection.getTransaction(byID: key)
            if transaction?.mode == .Expense {
                result.expense -= transaction!.amount
            } else if transaction?.mode == .Income {
                result.income += transaction!.amount
            }
        }
        
        result.balance = startingBalance + result.income + result.expense
        
        return result
    }
    
    private func calculateSummary(transaction: TransactionModel, summary: FinancialSummary) {
        switch transaction.mode {
        case .Expense:
            summary.expense -= transaction.amount
        case .Income:
            summary.income += transaction.amount
        case .none:
            break
        }
        summary.balance = startingBalance + summary.income + summary.expense
    }
    
}
