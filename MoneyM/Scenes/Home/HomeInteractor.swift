//
//  HomeInteractor.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//

import Foundation
import UIKit

protocol HomeBusinessLogic: AnyObject {
	func fetchTransactions(_ request: Home.FetchTransactions.Request)
	func fetchFinancialSummary(_ request: Home.FetchFinancialSummary.Request)
	func addTransaction(_ request: Home.AddTransaction.Request)
	func removeTransaction(_ request: Home.RemoveTransaction.Request)
	func editTransaction(_ request: Home.EditTransaction.Request)
	func editStartingBalance(_ request: Home.EditStartingBalance.Request)
	func showAlertEditStartingBalance(_ request: Home.AlertEditStartingBalance.Request)
	func showAlertDatePicker(_ request: Home.AlertDatePicker.Request)
	func updateDatePickerButton(_ request: Home.DatePickerButton.Request)
}

class HomeInteractor {
	
	public var presenter: HomePresentationLogic?
	
	private var transactions: [TransactionModel] = []
	
	private var financialSummary: FinancialSummaryModel!
	
	private var (year, month) = (0, 0)
	
	init() {
		_ = CategoriesManager.shared // Load categories
		
		(year, month) = currentDate()
		
		financialSummary = FinancialSummaryModel()
		
		loadStartingBalance()
		
		print("Documents Directory: ", FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last ?? "Not Found!")
	}
	
	private func loadStartingBalance() {
		financialSummary.startingBalance = UserDefaults.standard.double(forKey: UserDefaultKeys.startingBalance)
	}
	
	private func saveStartingBalance(_ value: Double) {
		UserDefaults.standard.setValue(value, forKey: UserDefaultKeys.startingBalance)
	}
	
	private func currentDate() -> (year: Int, month: Int) {
		let calendar = Calendar.current
		let dateComponents = calendar.dateComponents([.year, .month], from: Date.now)

		return (year: dateComponents.year!, month: dateComponents.month!)
	}
	
	private func getStartAndEndOfMonth(month: Int, year: Int) -> (start: Date?, end: Date?) {
		var components = DateComponents()
		components.day = 1
		components.month = month
		components.year = year
		
		if let startDate = Calendar.current.date(from: components) {
			if let range = Calendar.current.range(of: .day, in: .month, for: startDate) {
				components.day = range.count + 1
			}
			
			if let endDate = Calendar.current.date(from: components) {
				return (startDate, endDate)
			}
		}
		
		return (nil, nil)
	}
	
	private func calculateFinancialSummary(transactions: [TransactionModel]) {
		
		transactions.forEach { transaction in
			updateFinancialSummary(&financialSummary, transaction: transaction)
		}
		
	}
	
	private func updateFinancialSummary(_ summary: inout FinancialSummaryModel,
										transaction: TransactionModel) {
		switch transaction.transactionType {
			case .expense:
				summary.expense -= transaction.amount
			case .income:
				summary.income += transaction.amount
		}
	}
}

// MARK: - HomeBusinessLogic
extension HomeInteractor: HomeBusinessLogic {
	
	func fetchTransactions(_ request: Home.FetchTransactions.Request) {
		transactions = []
		
		
		year = request.year
		month = request.month
		
		let startAndEndOfMonth = getStartAndEndOfMonth(month: month, year: year)
		if let start = startAndEndOfMonth.start, let end = startAndEndOfMonth.end {
			let coreDataWorker = HomeCoreDataWorker()
			transactions = coreDataWorker.loadTransactions(from: start, to: end)
		}
		
		calculateFinancialSummary(transactions: transactions)
	
		let response = Home.FetchTransactions.Response(transactions: transactions)
		presenter?.presentTransactions(response)
	}

	func addTransaction(_ request: Home.AddTransaction.Request) {
		transactions.append(request.transaction)
		
		let coreDataWorker = HomeCoreDataWorker()
		coreDataWorker.saveTransaction(request.transaction)
		
		updateFinancialSummary(&financialSummary, transaction: request.transaction)

		let response = Home.AddTransaction.Response(transactions: transactions)
		presenter?.presentAddedTransaction(response)
	}

	func removeTransaction(_ request: Home.RemoveTransaction.Request) {
		var transaction = request.transaction
		
		transactions.removeAll { transactionModel in
			transactionModel.id == transaction.id
		}
		
		let coreDataWorker = HomeCoreDataWorker()
		coreDataWorker.deleteTransaction(transaction.id)
		
		transaction.amount *= -1
		updateFinancialSummary(&financialSummary, transaction: transaction)
		
		let response = Home.RemoveTransaction.Response(transactions: transactions)
		presenter?.presentRemoveTransaction(response)
	}

	func fetchFinancialSummary(_ request: Home.FetchFinancialSummary.Request) {
		let response = Home.FetchFinancialSummary.Response(summary: financialSummary)
		presenter?.presentFinancialSummary(response)
	}

	func editTransaction(_ request: Home.EditTransaction.Request) {
		let transactionID = request.transaction.id
		
		transactions.removeAll { $0.id == transactionID }
		transactions.append(request.transaction)
		
		let coreDataWorker = HomeCoreDataWorker()
		coreDataWorker.editTransaction(request.transaction)
		
		let response = Home.FetchTransactions.Response(transactions: transactions)
		presenter?.presentTransactions(response)
	}

	func editStartingBalance(_ request: Home.EditStartingBalance.Request) {
		let balanceStr = request.newBalance.replaceCommaToDot
		let balance = Double(balanceStr) ?? 0
		financialSummary.startingBalance = balance
		
		saveStartingBalance(balance)

		let response = Home.EditStartingBalance.Response(financialSummary: financialSummary)
		presenter?.presentStartingBalance(response)
	}

	func showAlertEditStartingBalance(_ request: Home.AlertEditStartingBalance.Request) {
		let response = Home.AlertEditStartingBalance.Response(action: request.action)
		presenter?.presentAlertEditStartingBalance(response)
	}

	func showAlertDatePicker(_ request: Home.AlertDatePicker.Request) {
		let response = Home.AlertDatePicker.Response(action: request.action)
		presenter?.presentAlertDatePicker(response)
	}

	func updateDatePickerButton(_ request: Home.DatePickerButton.Request) {
		let response = Home.DatePickerButton.Response(month: month, year: year)
		presenter?.presentDatePickerButton(response)
	}

}
