//
//  AnalyticsInteractor.swift
//  MoneyM
//
//  Created by savik on 05.01.2024.
//

import Foundation

protocol AnalyticsBusinessLogic {
	func fetchTransactions(_ request: AnalyticsModels.FetchTransactionsByMonth.Request)
}

class AnalyticsInteractor {
	
	public var presenter: AnalyticsPresentLogic?
	
}

// MARK: - Analytics business logic
extension AnalyticsInteractor: AnalyticsBusinessLogic {
	func fetchTransactions(_ request: AnalyticsModels.FetchTransactionsByMonth.Request) {
		let coreDataManager = CoreDataManager()
		let transactions = coreDataManager.load(year: request.year, month: request.month)
		
		let response = AnalyticsModels.FetchTransactionsByMonth.Response(transactions: transactions)
		presenter?.presentAnalyticsData(response)
	}
}
