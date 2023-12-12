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
}

// MARK: - Business logic
class HomeInteractor: HomeBusinessLogic {
	
	var presenter: HomePresentationLogic?
	
	private let transactionCollection: TransactionCollection
	
	init() {
		transactionCollection = TransactionCollection()
		
		print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
	}
	
	// MARK: HomeBusinessLogic
	
	func fetchTransactions(_ request: Home.FetchTransactions.Request) {
		
		let coreDataManager = CoreDataManager()
		let arr = coreDataManager.load(year: 2023, month: 12)
		
		transactionCollection.removeAll()
		transactionCollection.add(arr)
		
		let data = transactionCollection.data
		let response = Home.FetchTransactions.Response(data: data)
		presenter?.presentTransactions(response)
	}
	
	func addTransaction(request: Home.AddTransaction.Request) {
		transactionCollection.add(request.transaction)
		
		let coreDataManager = CoreDataManager()
		coreDataManager.add(request.transaction)
		
		let response = Home.FetchTransactions.Response(data: transactionCollection.data)
		presenter?.presentTransactions(response)
	}
	
	func removeTransaction(request: Home.RemoveTransaction.Request) {
		let id = request.transaction.id
		transactionCollection.removeBy(id)
		
		let coreDataManager = CoreDataManager()
		coreDataManager.delete(id)
		
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
		
		let response = Home.FetchTransactions.Response(data: transactionCollection.data)
		presenter?.presentTransactions(response)
	}
}
