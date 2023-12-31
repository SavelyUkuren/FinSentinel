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

// MARK: - Business logic
class HomeInteractor: HomeBusinessLogic {

	public var presenter: HomePresentationLogic?

	private let transactionCollection: TransactionCollection

	private var (year, month) = (0, 0)

	init() {
		_ = CategoriesManager.shared // Load categories
		transactionCollection = TransactionCollection()

		(year, month) = currentDate()

		print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
	}

	private func currentDate() -> (year: Int, month: Int) {
		let calendar = Calendar.current
		let dateComponents = calendar.dateComponents([.year, .month], from: Date.now)

		return (year: dateComponents.year!, month: dateComponents.month!)
	}

	// MARK: HomeBusinessLogic

	func fetchTransactions(_ request: Home.FetchTransactions.Request) {

		let coreDataManager = CoreDataManager()
		let arr = coreDataManager.load(year: request.year, month: request.month)
		year = request.year
		month = request.month

		transactionCollection.removeAll()
		transactionCollection.add(arr)
		transactionCollection.setStartingBalance(coreDataManager.startingBalance)

		let data = transactionCollection.transactionsGroupedByDate
		let response = Home.FetchTransactions.Response(data: data)
		presenter?.presentTransactions(response)
	}

	func addTransaction(_ request: Home.AddTransaction.Request) {
		transactionCollection.add(request.transaction)

		let coreDataManager = CoreDataManager()
		coreDataManager.add(request.transaction)
		let response = Home.FetchTransactions.Response(data: transactionCollection.transactionsGroupedByDate)
		presenter?.presentTransactions(response)
	}

	func removeTransaction(_ request: Home.RemoveTransaction.Request) {
		let id = request.transaction.id
		transactionCollection.removeBy(id)

		let coreDataManager = CoreDataManager()
		coreDataManager.delete(id)

		let response = Home.RemoveTransaction.Response(data: transactionCollection.transactionsGroupedByDate)
		presenter?.presentRemoveTransaction(response)
	}

	func fetchFinancialSummary(_ request: Home.FetchFinancialSummary.Request) {
		let response = Home.FetchFinancialSummary.Response(summary: transactionCollection.summary)
		presenter?.presentFinancialSummary(response)
	}

	func editTransaction(_ request: Home.EditTransaction.Request) {
		transactionCollection.editBy(id: request.transaction.id,
									 newTransaction: request.transaction)

		let coreDataManager = CoreDataManager()
		coreDataManager.edit(request.transaction.id,
							 request.transaction)

		let response = Home.FetchTransactions.Response(data: transactionCollection.transactionsGroupedByDate)
		presenter?.presentTransactions(response)
	}

	func editStartingBalance(_ request: Home.EditStartingBalance.Request) {
		let balance = Int(request.newBalance) ?? 0
		transactionCollection.setStartingBalance(balance)

		let coreDataManager = CoreDataManager()
		coreDataManager.editStartingBalance(year: year, month: month, newBalance: balance)

		let response = Home.RemoveTransaction.Response(data: transactionCollection.transactionsGroupedByDate)
		presenter?.presentRemoveTransaction(response)
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
