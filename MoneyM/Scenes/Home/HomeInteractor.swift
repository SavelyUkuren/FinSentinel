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
}

// MARK: - Business logic
class HomeInteractor: HomeBusinessLogic {
	
	var presenter: HomePresentationLogic?
	
	private let transactionCollection: TransactionCollection
	
	init() {
		transactionCollection = TransactionCollection()
		
		randomData()
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
		t3.date = Date(timeIntervalSince1970: 1701276337)
		t3.mode = .Income
		
		transactionCollection.append(t1)
		transactionCollection.append(t2)
		transactionCollection.append(t3)
	}
	
	func fetchTransactions(_ request: Home.FetchTransactions.Request) {
		
		let response = Home.FetchTransactions.Response(data: Array(transactionCollection.getValues()))
		presenter?.presentTransactions(response)
	}
	
	
}
