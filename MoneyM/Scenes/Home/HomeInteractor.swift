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
	
	init() {
		
			
	}
	
	func fetchTransactions(_ request: Home.FetchTransactions.Request) {
		var t = TransactionModel()
		t.amount = 100
		t.date = Date()
		t.id = 0
		t.mode = .Expense
		
		let response = Home.FetchTransactions.Response(data: [t])
		presenter?.presentTransactions(response)
	}
	
	
}
