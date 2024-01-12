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
	
	private func calculateTotalSumOfTransactions(transactions: [TransactionModel]) -> Int {
//		return transactions.reduce(into: 0) { amount, transaction in
//			amount += transaction.amount
//		}
		-1
	}
	
}

// MARK: - Analytics present logic
extension AnalyticsPresenter: AnalyticsPresentLogic {
	func presentAnalyticsData(_ response: AnalyticsModels.FetchTransactions.Response) {
		
		var categories: [AnalyticsModels.CategorySummaryModel] = []
		
		let groupedCategories = Dictionary(grouping: response.transactions,
										   by: { $0.categoryID! })
		
		groupedCategories.keys.forEach { categoryID in
			let categoryModel = CategoriesManager.shared.findCategoryBy(id: categoryID) ?? CategoriesManager.shared.defaultCategory
			let title = categoryModel.title
			let amount = calculateTotalSumOfTransactions(transactions: groupedCategories[categoryID] ?? [])
			
			categories.append(AnalyticsModels.CategorySummaryModel(icon: UIImage(systemName: categoryModel.icon) ?? UIImage(),
																   title: title,
																   amount: String(amount)))
		}
		
		let currencySymbol = Settings.shared.model.currency.symbol
		
		var summary: [FinancialSummaryCellModel] = []
		let amount = (response.mode == .expense) ? -response.totalAmount : response.totalAmount
		let amountString = amount.thousandSeparator + currencySymbol
		
		let totalAmountModel = FinancialSummaryCellModel(title: "Total amount",
														 amount: amountString,
														 amountColor: response.mode == .expense ? .systemRed : .systemGreen)
		
		summary.append(totalAmountModel)
		
		if response.period != .all {
			var averageTitle = ""
			if response.period == .month {
				averageTitle = "Average per day"
			} else if response.period == .year {
				averageTitle = "Average per months"
			}
			
			let average = (response.mode == .expense) ? -response.average : response.average
			let averageString = average.thousandSeparator + currencySymbol
			let averageModel = FinancialSummaryCellModel(title: averageTitle,
														 amount: averageString,
														 amountColor: response.mode == .expense ? .systemRed : .systemGreen)
			
			summary.append(averageModel)
		}
		
		let chartData = BarChartData(dataSet: response.chartDataSet)
		
		let viewModel = AnalyticsModels.FetchTransactions.ViewModel(categories: categories,
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
