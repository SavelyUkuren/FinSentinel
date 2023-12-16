//
//  HomeInteractor.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//

import Foundation
import UIKit

protocol HomeBusinessLogic {
	func fetchTransactions(_ request: Home.FetchTransactions.Request)
	func fetchFinancialSummary(request: Home.FetchFinancialSummary.Request)
	func addTransaction(request: Home.AddTransaction.Request)
	func removeTransaction(request: Home.RemoveTransaction.Request)
	func editTransaction(_ request: Home.EditTransaction.Request)
	func editStartingBalance(_ request: Home.EditStartingBalance.Request)
	func showAlertEditStartingBalance(_ request: Home.AlertEditStartingBalance.Request)
	func showAlertDatePicker(_ request: Home.AlertDatePicker.Request)
}

// MARK: - Business logic
class HomeInteractor: HomeBusinessLogic {

	var presenter: HomePresentationLogic?

	private let transactionCollection: TransactionCollection

	private var (year, month) = (0, 0)

	init() {
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

		transactionCollection.removeAll()
		transactionCollection.add(arr)
		transactionCollection.setStartingBalance(coreDataManager.startingBalance)

		let data = transactionCollection.data
		let response = Home.FetchTransactions.Response(data: data)
		presenter?.presentTransactions(response)
	}

	func addTransaction(request: Home.AddTransaction.Request) {
		transactionCollection.add(request.transaction)

		let coreDataManager = CoreDataManager()
		coreDataManager.add(request.transaction)
		coreDataManager.save()
		let response = Home.FetchTransactions.Response(data: transactionCollection.data)
		presenter?.presentTransactions(response)
	}

	func removeTransaction(request: Home.RemoveTransaction.Request) {
		let id = request.transaction.id
		transactionCollection.removeBy(id)

		let coreDataManager = CoreDataManager()
		coreDataManager.delete(id)
		coreDataManager.save()

		let response = Home.RemoveTransaction.Response(data: transactionCollection.data)
		presenter?.presentRemoveTransaction(response)
	}

	func fetchFinancialSummary(request: Home.FetchFinancialSummary.Request) {
		let response = Home.FetchFinancialSummary.Response(summary: transactionCollection.summary)
		presenter?.presentFinancialSummary(response)
	}

	func editTransaction(_ request: Home.EditTransaction.Request) {
		transactionCollection.editBy(id: request.transaction.id,
									 newTransaction: request.transaction)

		let coreDataManager = CoreDataManager()
		coreDataManager.edit(request.transaction.id,
							 request.transaction)
		coreDataManager.save()

		let response = Home.FetchTransactions.Response(data: transactionCollection.data)
		presenter?.presentTransactions(response)
	}

	func editStartingBalance(_ request: Home.EditStartingBalance.Request) {
		let balance = Int(request.newBalance) ?? 0
		transactionCollection.setStartingBalance(balance)

		let coreDataManager = CoreDataManager()
		coreDataManager.editStartingBalance(year: year, month: month, newBalance: balance)
		coreDataManager.save()

		let response = Home.RemoveTransaction.Response(data: transactionCollection.data)
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
}
