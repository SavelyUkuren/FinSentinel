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
}

// MARK: - Business logic
class HomeInteractor: HomeBusinessLogic {
	
	var presenter: HomePresentationLogic?
	
	private let transactionCollection: TransactionCollection
	
	init() {
		transactionCollection = TransactionCollection()
		
		//randomData()
		
		print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
	}
	
	private func randomData() {
		var t1 = TransactionModel()
		t1.amount = 1
		t1.date = Date(timeIntervalSince1970: 1701362737)
		t1.mode = .Expense
		
		var t2 = TransactionModel()
		t2.amount = 2
		t2.date = Date(timeIntervalSince1970: 1701276337)
		t2.mode = .Income
		
		var t3 = TransactionModel()
		t3.amount = 3
		t3.date = Date(timeIntervalSince1970: 1701296337)
		t3.mode = .Income
		
		transactionCollection.add(t1)
		transactionCollection.add(t1)
		transactionCollection.add(t2)
		transactionCollection.add(t2)
		transactionCollection.add(t2)
		transactionCollection.add(t3)
		transactionCollection.add(t3)
		transactionCollection.add(t3)
		transactionCollection.add(t3)
		
		transactionCollection.printTransactions()
	}
	
	// MARK: HomeBusinessLogic
	
	func fetchTransactions(_ request: Home.FetchTransactions.Request) {
		
		let coreDataManager = CoreDataManager()
		let arr = coreDataManager.load(year: 2023, month: 12)
		
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
	
	func fetchFinancialSummary(request: Home.FetchFinancialSummary.Request) {
		let response = Home.FetchFinancialSummary.Response(summary: transactionCollection.summary)
		presenter?.presentFinancialSummary(response)
	}
}
