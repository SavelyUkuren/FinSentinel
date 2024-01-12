//
//  TransactionCollection.swift
//  MoneyM
//
//  Created by Air on 03.12.2023.
//

import Foundation

//class TransactionData {
//	var date: Date = Date()
//	var transactions: [TransactionModel] = []
//}
//
///* Structure of Collection look's like
//	Day Month
//		Transaction 1
//		Transaction 2
//	Day Month
//		Transaction 3
//		Transaction 4
// */
//
//class TransactionCollection {
//
//	private(set) var transactionsGroupedByDate: [TransactionData] = []
//
//	private(set) var summary = FinancialSummary()
//
//	private var transactionsCount = 0
//
//	init() {
//
//	}
//
//	func add(_ transaction: TransactionModel) {
//
//		if let index = firstIndexInGroupedTransactions(byDate: transaction.date!) {
//			transactionsGroupedByDate[index].transactions.append(transaction)
//		} else {
//			createData(date: transaction.date!, transaction: transaction)
//		}
//
//		summaryUpdate(transaction)
//
//		transactionsCount += 1
//	}
//
//	func add(_ transactions: [TransactionModel]) {
//		transactions.forEach { model in
//			add(model)
//		}
//	}
//
//	func editBy(id: UUID, newTransaction: TransactionModel) {
//		let foundTransactionIndex = firstIndex(id)
//
//		// Change summary before edit transaction
//		let transactionModel = findTransactionBy(id)
//		if let unwrapTransaction = transactionModel {
//			unwrapTransaction.amount *= -1
//			summaryUpdate(unwrapTransaction)
//		}
//
//		if let unwrapIndex = foundTransactionIndex {
//
//			transactionsGroupedByDate[unwrapIndex.section].transactions[unwrapIndex.row] = newTransaction
//			summaryUpdate(newTransaction)
//		}
//	}
//
//	// Finding transaction indexPath in 'transactionsGroupedByDate' array
//	func firstIndex(_ id: UUID) -> IndexPath? {
//		// section = date, row = transaction
//		var indexPath = IndexPath(row: 0, section: 0)
//
//		for transactionData in transactionsGroupedByDate {
//			let index = transactionData.transactions.firstIndex { transaction in
//				transaction.id == id
//			}
//			if index != nil {
//				indexPath.row = index!
//				return indexPath
//			}
//			indexPath.section += 1
//		}
//		return nil
//	}
//
//	func findTransactionBy(_ id: UUID) -> TransactionModel? {
//		return transactionsGroupedByDate.compactMap {
//			$0.transactions.first { $0.id == id }
//		}.first
//	}
//
//	func removeBy(_ id: UUID) {
//		for (index, currentData) in transactionsGroupedByDate.enumerated() {
//
//			let transactionIndex = currentData.transactions.firstIndex { transaction in
//				transaction.id == id
//			}
//
//			if transactionIndex != nil {
//				let removedTransaction = transactionsGroupedByDate[index].transactions.remove(at: transactionIndex!)
//				// multiply by -1 so that the amount that was deleted is added to the balance
//				removedTransaction.amount *= -1
//				summaryUpdate(removedTransaction)
//
//				if transactionsGroupedByDate[index].transactions.isEmpty {
//					transactionsGroupedByDate.remove(at: index)
//				}
//			}
//
//		}
//
//	}
//
//	func removeAll() {
//		summary.expense = 0
//		summary.income = 0
//		transactionsGroupedByDate.removeAll()
//	}
//
//	func setStartingBalance(_ value: Int) {
//		summary.startingBalance = value
//	}
//
//	func printTransactions() {
//		for tData in transactionsGroupedByDate {
//			print("\(getDateComponent(tData.date).day!) \(getDateComponent(tData.date).month!)")
//			for transaction in tData.transactions {
//				print("\t\(transaction.amount!)\t\(TransactionModel.Mode(rawValue: transaction.mode?.rawValue ?? 0)!)")
//			}
//		}
//	}
//
//	private func getDateComponent(_ date: Date) -> DateComponents {
//		let calendar = Calendar.current
//		return calendar.dateComponents([.day, .month], from: date)
//	}
//
//	private func firstIndexInGroupedTransactions(byDate date: Date) -> Int? {
//		let dateComponent = getDateComponent(date)
//		// Find index by day and month in TransactionData
//		let index = transactionsGroupedByDate.firstIndex { transactionData in
//			dateComponent.day == getDateComponent(transactionData.date).day &&
//			dateComponent.month == getDateComponent(transactionData.date).month
//		}
//		return index
//	}
//
//	private func summaryUpdate(_ transaction: TransactionModel) {
//		switch transaction.mode {
//		case .expense:
//			summary.expense -= transaction.amount
//		case .income:
//			summary.income += transaction.amount
//		case .none:
//			break
//		}
//	}
//
//	private func createData(date: Date, transaction: TransactionModel) {
//		let tData = TransactionData()
//		tData.date = transaction.date!
//		tData.transactions.append(transaction)
//		transactionsGroupedByDate.append(tData)
//	}
//
//}
