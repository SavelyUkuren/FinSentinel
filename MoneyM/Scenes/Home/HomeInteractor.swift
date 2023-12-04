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
	func addTransaction(request: Home.AddTransaction.Request)
}

// MARK: - Business logic
class HomeInteractor: HomeBusinessLogic {
	
	var presenter: HomePresentationLogic?
	
	private let transactionCollection: TransactionCollection
	
	init() {
		transactionCollection = TransactionCollection()
		
		//randomData()
	}
	
	private func randomData() {
		var t1 = TransactionModel()
		t1.amount = 101
		t1.date = Date(timeIntervalSince1970: 1701362737)
		t1.mode = .Expense
		
		var t2 = TransactionModel()
		t2.amount = 102
		t2.date = Date(timeIntervalSince1970: 1701276337)
		t2.mode = .Income
		
		var t3 = TransactionModel()
		t3.amount = 103
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
	
	func fetchTransactions(_ request: Home.FetchTransactions.Request) {
		
		let response = Home.FetchTransactions.Response(data: transactionCollection.data)
		presenter?.presentTransactions(response)
	}
	
	func addTransaction(request: Home.AddTransaction.Request) {
		transactionCollection.add(request.transaction)
		
		let response = Home.FetchTransactions.Response(data: transactionCollection.data)
		presenter?.presentTransactions(response)
	}
}
