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
	
	private var transactionsCount = 0
	
	init() {
		
	}
	
	func add(_ transaction: TransactionModel) {
		let index = findIndexIn(array: data, byDate: transaction.date!)
		
		transaction.id = transactionsCount
		
		if let index = index {
			data[index].transactions.append(transaction)
		} else {
			let tData = TransactionData()
			tData.date = transaction.date!
			tData.transactions.append(transaction)
			data.append(tData)
		}
		
		transactionsCount += 1
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
				data[i].transactions.remove(at: index!)
				
				if data[i].transactions.isEmpty {
					data.remove(at: i)
				}
			}
			
		}
		
	}
	
	func printTransactions() {
		for tData in data {
			print ("\(getDateComponent(tData.date).day!) \(getDateComponent(tData.date).month!)")
			for transaction in tData.transactions {
				print ("\t\(transaction.amount!)")
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
	
	
	
}
