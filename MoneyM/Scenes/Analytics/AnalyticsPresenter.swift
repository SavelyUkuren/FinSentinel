//
//  AnalyticsPresenter.swift
//  MoneyM
//
//  Created by savik on 05.01.2024.
//

import Foundation
import UIKit
import DGCharts

protocol AnalyticsPresentLogic {
	func presentAnalyticsData(_ response: AnalyticsModels.FetchTransactions.Response)
	func presentMonthYearWheelAlert(_ response: AnalyticsModels.ShowMonthYearWheel.Response)
	func presentYearsWheelAlert(_ response: AnalyticsModels.ShowYearsWheel.Response)
}

class AnalyticsPresenter {
	
	public var viewController: AnalyticsDisplayLogic?
	
	private func calculateTotalSumOfTransactions(transactions: [TransactionModel]) -> Double {
		return transactions.reduce(into: 0) { amount, transaction in
			amount += transaction.amount
		}
	}
	
	private func calculateCategoryTotals(_ transactions: [TransactionModel]) -> [AnalyticsModels.CategorySummaryModel] {
		var categories: [AnalyticsModels.CategorySummaryModel] = []
		
		let groupedCategories = Dictionary(grouping: transactions,
										   by: { $0.categoryID! })
		
		groupedCategories.keys.forEach { categoryID in
			let categoryModel = CategoriesManager.shared.findCategoryBy(id: categoryID) ?? CategoriesManager.shared.defaultCategory
			let title = categoryModel.title
			let amount = calculateTotalSumOfTransactions(transactions: groupedCategories[categoryID] ?? [])
			
			categories.append(AnalyticsModels.CategorySummaryModel(icon: UIImage(systemName: categoryModel.icon) ?? UIImage(),
																   title: title,
																   amount: String(amount)))
		}
		
		return categories
	}
	
	private func averageByDayModel(_ average: Double) -> FinancialSummaryCellModel {
		let currencySymbol = Settings.shared.model.currency.symbol
		
		let amount = "\(average.thousandSeparator) \(currencySymbol)"
		
		return FinancialSummaryCellModel(title: "Average by Day",
										 amount: amount,
										 amountColor: average < 0 ? .systemRed : .systemGreen)
	}
	
	private func averageByMonthModel(_ average: Double) -> FinancialSummaryCellModel {
		let currencySymbol = Settings.shared.model.currency.symbol
		
		let amount = "\(average.thousandSeparator) \(currencySymbol)"
		
		return FinancialSummaryCellModel(title: "Average by Month",
										 amount: amount,
										 amountColor: average < 0 ? .systemRed : .systemGreen)
	}
	
	private func totalAmountModel(_ amount: Double) -> FinancialSummaryCellModel {
		let currencySymbol = Settings.shared.model.currency.symbol
		
		let totalAmount = "\(amount.thousandSeparator) \(currencySymbol)"
		
		return FinancialSummaryCellModel(title: "Total amount",
										 amount: totalAmount,
										 amountColor: amount < 0 ? .systemRed : .systemGreen)
	}
	
}

// MARK: - Analytics present logic
extension AnalyticsPresenter: AnalyticsPresentLogic {
	func presentAnalyticsData(_ response: AnalyticsModels.FetchTransactions.Response) {
		
		let categoriesSummary = calculateCategoryTotals(response.transactions)
		
		var summary: [FinancialSummaryCellModel] = []
		
		let totalAmount = (response.transactionType == .expense) ? -response.totalAmount : response.totalAmount
		let totalAmountModel = totalAmountModel(totalAmount)
		
		summary.append(totalAmountModel)
		
		if response.period == .month {
			
			let average = (response.transactionType == .expense) ? -response.average : response.average
			let averageByDay = averageByDayModel(average)
			
			summary.append(averageByDay)
			
		} else if response.period == .year {
			
			let average = (response.transactionType == .expense) ? -response.average : response.average
			let averageByMonth = averageByMonthModel(average)
			
			summary.append(averageByMonth)
			
		}
		
		let chartData = BarChartData(dataSet: response.chartDataSet)
		
		let viewModel = AnalyticsModels.FetchTransactions.ViewModel(categories: categoriesSummary,
																	summary: summary,
																	chartData: chartData)
		viewController?.displayAnalyticsData(viewModel)
	}
	
	func presentMonthYearWheelAlert(_ response: AnalyticsModels.ShowMonthYearWheel.Response) {
		let datePickerVC = UIViewController()
		
		let pickerView = MonthYearWheelPicker()

		pickerView.minimumDate = Date(timeIntervalSince1970: 0)
		pickerView.maximumDate = .now

		datePickerVC.view = pickerView
		
		let alert = UIAlertController(title: NSLocalizedString("select_date.title", comment: ""), message: nil, preferredStyle: .actionSheet)
		alert.setValue(datePickerVC, forKey: "contentViewController")
		
		let selectAction = UIAlertAction(title: NSLocalizedString("select.title", comment: ""), style: .default) { _ in
			response.action(pickerView.month, pickerView.year)
		}

		let cancelAction = UIAlertAction(title: NSLocalizedString("cancel.title", comment: ""), style: .destructive) {_ in
			alert.dismiss(animated: true)
		}

		alert.addAction(selectAction)
		alert.addAction(cancelAction)
		
		let viewModel = AnalyticsModels.ShowMonthYearWheel.ViewModel(alert: alert)
		viewController?.displayMonthYearWheelAlert(viewModel)
	}
	
	func presentYearsWheelAlert(_ response: AnalyticsModels.ShowYearsWheel.Response) {
		let datePickerVC = UIViewController()
		
		let pickerView = YearWheelPicker()

		datePickerVC.view = pickerView
		
		let alert = UIAlertController(title: NSLocalizedString("select_date.title", comment: ""), message: nil, preferredStyle: .actionSheet)
		alert.setValue(datePickerVC, forKey: "contentViewController")
		
		let selectAction = UIAlertAction(title: NSLocalizedString("select.title", comment: ""), style: .default) { _ in
			response.action(pickerView.selectedYear)
		}

		let cancelAction = UIAlertAction(title: NSLocalizedString("cancel.title", comment: ""), style: .destructive) {_ in
			alert.dismiss(animated: true)
		}

		alert.addAction(selectAction)
		alert.addAction(cancelAction)
		
		let viewModel = AnalyticsModels.ShowYearsWheel.ViewModel(alert: alert)
		viewController?.displayYearsWheelAlert(viewModel)
	}
	
}
