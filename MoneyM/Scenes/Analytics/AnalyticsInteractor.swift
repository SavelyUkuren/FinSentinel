//
//  AnalyticsInteractor.swift
//  MoneyM
//
//  Created by savik on 05.01.2024.
//

import Foundation

protocol AnalyticsBusinessLogic {
	func fetchTransactions(_ request: AnalyticsModels.FetchTransactions.Request)
	func showMonthAndYearWheelAlert(_ request: AnalyticsModels.ShowMonthYearWheel.Request)
	func showYearsWheelAlert(_ request: AnalyticsModels.ShowYearsWheel.Request)
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
		
		// Filtering transactions by selected mode (expense or income)
		if request.mode == .expense {
			transactions = transactions.filter { transactionModel in
				transactionModel.mode == .expense
			}
		}
		else if request.mode == .income {
			transactions = transactions.filter { transactionModel in
				transactionModel.mode == .income
			}
		}
		
		let response = AnalyticsModels.FetchTransactions.Response(transactions: transactions)
		presenter?.presentAnalyticsData(response)
	}
	
	func showMonthAndYearWheelAlert(_ request: AnalyticsModels.ShowMonthYearWheel.Request) {
		let response = AnalyticsModels.ShowMonthYearWheel.Response(action: request.action)
		presenter?.presentMonthYearWheelAlert(response)
	}
	
	func showYearsWheelAlert(_ request: AnalyticsModels.ShowYearsWheel.Request) {
		let response = AnalyticsModels.ShowYearsWheel.Response(action: request.action)
		presenter?.presentYearsWheelAlert(response)
	}
	
}
