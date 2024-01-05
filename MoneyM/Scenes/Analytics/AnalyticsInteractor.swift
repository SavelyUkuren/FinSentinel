//
//  AnalyticsInteractor.swift
//  MoneyM
//
//  Created by savik on 05.01.2024.
//

import Foundation

protocol AnalyticsBusinessLogic {
	func fetchTransactions(_ request: AnalyticsModels.FetchTransactions.Request)
}

class AnalyticsInteractor {
	
	public var presenter: AnalyticsPresentLogic?
	
}

// MARK: - Analytics business logic
extension AnalyticsInteractor: AnalyticsBusinessLogic {
	func fetchTransactions(_ request: AnalyticsModels.FetchTransactions.Request) {
		let coreDataManager = CoreDataManager()
		
		var transactions: [TransactionModel] = []
		
		switch request.period {
			case .month:
				transactions = coreDataManager.load(year: request.year, month: request.month)
			case .year:
				transactions = coreDataManager.load(year: request.year)
			case .all:
				transactions = coreDataManager.load()
				break
		}
		
		let response = AnalyticsModels.FetchTransactions.Response(transactions: transactions)
		presenter?.presentAnalyticsData(response)
	}
}
