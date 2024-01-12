//
//  AnalyticsInteractor.swift
//  MoneyM
//
//  Created by savik on 05.01.2024.
//

import Foundation
import DGCharts

protocol AnalyticsBusinessLogic {
	func fetchTransactions(_ request: AnalyticsModels.FetchTransactions.Request)
	func showMonthAndYearWheelAlert(_ request: AnalyticsModels.ShowMonthYearWheel.Request)
	func showYearsWheelAlert(_ request: AnalyticsModels.ShowYearsWheel.Request)
}

class AnalyticsInteractor {
	
	public var presenter: AnalyticsPresentLogic?
	
	private func maxDaysInMonth(month: Int, year: Int) -> Int? {
		guard month >= 1 && month <= 12 else { return nil }
		
		func isLeapYear(year: Int) -> Bool {
			return year % 4 == 0
		}
		
		var daysArray = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
		
		if month == 2 {
			daysArray[1] += 1
		}
		
		return daysArray[month - 1]
	}
	
}

// MARK: - Analytics business logic
extension AnalyticsInteractor: AnalyticsBusinessLogic {
	func fetchTransactions(_ request: AnalyticsModels.FetchTransactions.Request) {
//		let coreDataManager = CoreDataManager()
//		
//		var transactions: [TransactionModel] = []
//		
//		switch request.period {
//			case .month:
//				transactions = coreDataManager.load(year: request.year, month: request.month)
//			case .year:
//				transactions = coreDataManager.load(year: request.year)
//			case .all:
//				transactions = coreDataManager.load()
//				break
//		}
//		
//		// Filtering transactions by selected mode (expense or income)
//		if request.mode == .expense {
//			transactions = transactions.filter { transactionModel in
//				transactionModel.mode == .expense
//			}
//		}
//		else if request.mode == .income {
//			transactions = transactions.filter { transactionModel in
//				transactionModel.mode == .income
//			}
//		}
//		
//		let totalAmount = transactions.reduce(0, { $0 + $1.amount })
//		var averageByPeriod = -1
//		if request.period == .month {
//			if let maxDays = maxDaysInMonth(month: request.month, year: request.year) {
//				averageByPeriod = totalAmount / maxDays
//			}
//		} else if request.period == .year {
//			averageByPeriod = totalAmount / 12
//		}
//		
//		let dataSet = BarChartDataSet(entries: [])
//		
//		if request.period == .month {
//			for day in 1...maxDaysInMonth(month: request.month, year: request.year)! {
//				dataSet.append(BarChartDataEntry(x: Double(day), y: 0))
//			}
//			
//			let groupedTransactionsByDay = Dictionary(grouping: transactions) { transaction in
//				Calendar.current.dateComponents([.day], from: transaction.date)
//			}
//			
//			groupedTransactionsByDay.keys.forEach { key in
//				let dayTotalAmount = groupedTransactionsByDay[key]?.reduce(0, { $0 + $1.amount })
//				dataSet[key.day!] = BarChartDataEntry(x: Double(key.day!), y: Double(dayTotalAmount!))
//			}
//		} else if request.period == .year {
//			for day in 1...12 {
//				dataSet.append(BarChartDataEntry(x: Double(day), y: 0))
//			}
//			
//			let groupedTransactionsByDay = Dictionary(grouping: transactions) { transaction in
//				Calendar.current.dateComponents([.month], from: transaction.date)
//			}
//			
//			groupedTransactionsByDay.keys.forEach { key in
//				let monthTotalAmount = groupedTransactionsByDay[key]?.reduce(0, { $0 + $1.amount })
//				dataSet[key.month! - 1] = BarChartDataEntry(x: Double(key.month!), y: Double(monthTotalAmount!))
//			}
//		}
//		
//		
//		
//		let response = AnalyticsModels.FetchTransactions.Response(transactions: transactions,
//																  chartDataSet: dataSet,
//																  mode: request.mode,
//																  period: request.period,
//																  totalAmount: totalAmount,
//																  average: averageByPeriod)
//		presenter?.presentAnalyticsData(response)
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
