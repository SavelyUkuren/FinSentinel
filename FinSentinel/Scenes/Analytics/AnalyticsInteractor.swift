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
	func updatePeriodButtonTitle(_ request: AnalyticsModels.UpdatePeriodButtonTitle.Request)
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
	
	private func calculateTotalAmount(_ transactions: [TransactionModel]) -> Double {
		transactions.reduce(0, { $0 + $1.amount })
	}
	
	private func calculateAverageByMonth(_ amount: Double, month: Int, year: Int) -> Double {
		var averageByPeriod = 0.0
		if let maxDays = maxDaysInMonth(month: month, year: year) {
			averageByPeriod = amount / Double(maxDays)
		}
		return averageByPeriod
	}
	
	private func calculateAverageByYear(_ amount: Double) -> Double {
		return amount / 12
	}
	
	private func configureChartDataSet(period: AnalyticsModels.Period, transactions: [TransactionModel], month: Int, year: Int) -> BarChartDataSet {
		let dataSet = BarChartDataSet(entries: [])
		
		if period == .month {
			for day in 1...maxDaysInMonth(month: month, year: year)! {
				dataSet.append(BarChartDataEntry(x: Double(day), y: 0))
			}
			
			let groupedTransactionsByDay = Dictionary(grouping: transactions) { transaction in
				Calendar.current.dateComponents([.day], from: transaction.dateOfCreation)
			}
			
			groupedTransactionsByDay.keys.forEach { key in
				let dayTotalAmount = groupedTransactionsByDay[key]?.reduce(0, { $0 + $1.amount })
				dataSet[key.day!] = BarChartDataEntry(x: Double(key.day!), y: Double(dayTotalAmount!))
			}
		} else if period == .year {
			for day in 1...12 {
				dataSet.append(BarChartDataEntry(x: Double(day), y: 0))
			}
			
			let groupedTransactionsByDay = Dictionary(grouping: transactions) { transaction in
				Calendar.current.dateComponents([.month], from: transaction.dateOfCreation)
			}
			
			groupedTransactionsByDay.keys.forEach { key in
				let monthTotalAmount = groupedTransactionsByDay[key]?.reduce(0, { $0 + $1.amount })
				dataSet[key.month! - 1] = BarChartDataEntry(x: Double(key.month!), y: Double(monthTotalAmount!))
			}
		}
		
		return dataSet
	}
	
}

// MARK: - Analytics business logic
extension AnalyticsInteractor: AnalyticsBusinessLogic {
	func fetchTransactions(_ request: AnalyticsModels.FetchTransactions.Request) {
		let coreDataWorker = AnalyticsCoreDataWorker()
		
		var transactions: [TransactionModel] = []
		
		switch request.period {
			case .month:
				let startAndEndOfMonth = Date().startAndEndOfMonth(month: request.month, year: request.year)
				if let start = startAndEndOfMonth.start, let end = startAndEndOfMonth.end {
					transactions = coreDataWorker.loadTransactions(from: start, to: end)
				}
			case .year:
				let startAndEndOfYear = Date().startAndEndOfYear(year: request.year)
				if let start = startAndEndOfYear.start, let end = startAndEndOfYear.end {
					transactions = coreDataWorker.loadTransactions(from: start, to: end)
				}
			case .all:
				transactions = coreDataWorker.loadAll()
		}
		
		// Filtering transactions by selected transaction type (expense or income)
		if request.transactionType == .expense {
			transactions = transactions.filter { transactionModel in
				transactionModel.transactionType == .expense
			}
		}
		else if request.transactionType == .income {
			transactions = transactions.filter { transactionModel in
				transactionModel.transactionType == .income
			}
		}
		
		let totalAmount = calculateTotalAmount(transactions)
		var averageByPeriod: Double = -1
		if request.period == .month {
			averageByPeriod = calculateAverageByMonth(totalAmount, month: request.month, year: request.year)
		} else if request.period == .year {
			averageByPeriod = calculateAverageByYear(totalAmount)
		}
		
		let dataSet = configureChartDataSet(period: request.period,
											transactions: transactions,
											month: request.month, year: request.year)
		
		let response = AnalyticsModels.FetchTransactions.Response(transactions: transactions,
																  chartDataSet: dataSet,
																  transactionType: request.transactionType,
																  period: request.period,
																  totalAmount: totalAmount,
																  average: averageByPeriod)
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
	
	func updatePeriodButtonTitle(_ request: AnalyticsModels.UpdatePeriodButtonTitle.Request) {
		let response = AnalyticsModels.UpdatePeriodButtonTitle.Response(month: request.month,
																		year: request.year)
		presenter?.presentPeriodButtonTitle(response)
	}
	
}
