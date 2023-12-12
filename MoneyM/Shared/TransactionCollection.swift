//
//  TransactionCollection.swift
//  MoneyM
//
//  Created by Air on 03.12.2023.
//

import Foundation

class TransactionData {
	var date: Date = Date()
	var transactions: [TransactionModel] = []
}

class TransactionCollection {
	
	/* Structure of array look like
		Day Month
			Transaction 1
			Transaction 2
		Day Month
			Transaction 3
			Transaction 4
	 */
	private(set) var data: [TransactionData] = []
	
	private(set) var summary = FinancialSummary()
	
	private var transactionsCount = 0
	
	init() {
		
	}
	
	func add(_ transaction: TransactionModel) {
		let index = findIndexIn(array: data, byDate: transaction.date!)
		
		if transaction.id == 0 { // if ID not changed
			transaction.id = transactionsCount
		}
		
		if let index = index {
			data[index].transactions.append(transaction)
		} else {
			let tData = TransactionData()
			tData.date = transaction.date!
			tData.transactions.append(transaction)
			data.append(tData)
		}
		
		summaryUpdate(transaction)
		
		transactionsCount += 1
	}
	
	func add(_ transactions: [TransactionModel]) {
		transactions.forEach { model in
			add(model)
		}
	}
	
	func editBy(id: Int, newTransaction: TransactionModel) {
		let foundTransactionIndex = firstIndex(id)
		
		// Change summary before edit transaction
		let transactionModel = findBy(id)
		if let unwrapTransaction = transactionModel {
			unwrapTransaction.amount *= -1
			summaryUpdate(unwrapTransaction)
		}
		
		
		if let unwrapIndex = foundTransactionIndex {
			
			data[unwrapIndex.section].transactions[unwrapIndex.row] = newTransaction
			summaryUpdate(newTransaction)
		}
	}
	
	func firstIndex(_ id: Int) -> IndexPath? {
		var indexPath = IndexPath(row: 0, section: 0)
		
		for data in data {
			let index = data.transactions.firstIndex { transaction in
				transaction.id == id
			}
			if index != nil {
				indexPath.row = index!
				return indexPath
			}
			indexPath.section += 1
		}
		return nil
	}
	
	func findBy(_ id: Int) -> TransactionModel? {
		
		for data in data {
			let foundTransaction = data.transactions.first { transaction in
				transaction.id == id
			}
			if foundTransaction != nil {
				return foundTransaction
			}
		}
		
		return nil
	}
	
	func removeBy(_ id: Int) {
		for (i, currentData) in data.enumerated() {
			
			let index = currentData.transactions.firstIndex { transaction in
				transaction.id == id
			}
			
			if index != nil {
				let removedTransaction = data[i].transactions.remove(at: index!)
				removedTransaction.amount *= -1
				summaryUpdate(removedTransaction)
				
				if data[i].transactions.isEmpty {
					data.remove(at: i)
				}
			}
			
		}
		
	}
	
	func removeAll() {
		summary.expense = 0
		summary.income = 0
		data.removeAll()
	}
	
	func printTransactions() {
		for tData in data {
			print ("\(getDateComponent(tData.date).day!) \(getDateComponent(tData.date).month!)")
			for transaction in tData.transactions {
				print ("\t\(transaction.amount!)\t\(TransactionModel.Mode(rawValue: transaction.mode?.rawValue ?? 0)!)")
			}
		}
	}
	
	private func getDateComponent(_ date: Date) -> DateComponents {
		let calendar = Calendar.current
		return calendar.dateComponents([.day, .month], from: date)
	}
	
	private func findIndexIn(array: [TransactionData], byDate date: Date) -> Int? {
		let dateComponent = getDateComponent(date)
		// Find index by day and month in TransactionData
		let index = array.firstIndex { transactionData in
			dateComponent.day == getDateComponent(transactionData.date).day &&
			dateComponent.month == getDateComponent(transactionData.date).month
		}
		return index
	}
	
	private func summaryUpdate(_ transaction: TransactionModel) {
		switch transaction.mode {
		case .Expense:
			summary.expense -= transaction.amount
		case .Income:
			summary.income += transaction.amount
		case .none:
			break
		}
	}
	
}
