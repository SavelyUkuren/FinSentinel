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
	func presentPeriodButtonTitle(_ response: AnalyticsModels.UpdatePeriodButtonTitle.Response)
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
		
		// This temp struct needs to sort categories by amount
		struct CategorySummaryModelAmountDouble {
			var icon: UIImage
			var title: String
			var amount: Double
		}
		
		func calculateCategoriesAmountAndSort(groupedCategories: Dictionary<Int, [TransactionModel]>) -> [AnalyticsModels.CategorySummaryModel] {
			var tempCategories: [CategorySummaryModelAmountDouble] = []
			
			groupedCategories.keys.forEach { categoryID in
				let categoriesManager = CategoriesManager.shared
				let categoryModel: CategoryProtocol = categoriesManager.defaultCategory
				
				var categorySummaryModel = CategorySummaryModelAmountDouble(icon: UIImage(named: categoryModel.icon) ?? UIImage(),
																	   title: categoryModel.title,
																	   amount: 0)
				
				if let foundedCategoryModel = categoriesManager.findCategory(id: categoryID) {
					let title = foundedCategoryModel.title
					let amount = calculateTotalSumOfTransactions(transactions: groupedCategories[categoryID] ?? [])

					categorySummaryModel.title = title
					categorySummaryModel.icon = UIImage(named: foundedCategoryModel.icon) ?? UIImage()
					categorySummaryModel.amount = amount
				}
				
				tempCategories.append(categorySummaryModel)
				
			}
			
			tempCategories.sort(by: { $0.amount > $1.amount })
			
			let result = tempCategories.map {
				let currency = Settings.shared.model.currency.symbol
				let amountStr = "\($0.amount.thousandSeparator) \(currency)"
				
				return AnalyticsModels.CategorySummaryModel(icon: $0.icon,
													 title: $0.title,
													 amount: amountStr)
			}
			
			return result
		}
		
		let groupedCategories = Dictionary(grouping: transactions,
										   by: { $0.categoryID! })
		
		categories = calculateCategoriesAmountAndSort(groupedCategories: groupedCategories)
		
		return categories
	}
	
	private func averageByDayModel(_ average: Double) -> FinancialSummaryCellModel {
		return FinancialSummaryCellModel(title: NSLocalizedString("average_per_day.title", comment: ""),
										 amount: average)
	}
	
	private func averageByMonthModel(_ average: Double) -> FinancialSummaryCellModel {
		return FinancialSummaryCellModel(title: NSLocalizedString("average_per_month.title", comment: ""),
										 amount: average)
	}
	
	private func totalAmountModel(_ amount: Double) -> FinancialSummaryCellModel {
		return FinancialSummaryCellModel(title: NSLocalizedString("total_amount.title", comment: ""),
										 amount: amount)
	}
	
}

// MARK: - Analytics present logic
extension AnalyticsPresenter: AnalyticsPresentLogic {
	func presentAnalyticsData(_ response: AnalyticsModels.FetchTransactions.Response) {
		
		var categoriesSummary = calculateCategoryTotals(response.transactions)
		for index in 0..<categoriesSummary.count {
			categoriesSummary[index].amountColor = response.transactionType == .expense ? .systemRed : .systemGreen
		}
		
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
		
		let dataSet = response.chartDataSet
		dataSet.colors = [.systemBlue]
		
		let chartData = BarChartData(dataSet: dataSet)
		
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
	
	func presentPeriodButtonTitle(_ response: AnalyticsModels.UpdatePeriodButtonTitle.Response) {
		var dateComponents = DateComponents()
		dateComponents.month = response.month
		dateComponents.year = response.year

		let date = Calendar.current.date(from: dateComponents)
		
		let title = switch date {
		case .none:
			   "\(response.month) \(response.year)"
		case .some(_):
			"\(date!.monthTitle) \(response.year)"
	   }

		let viewModel = AnalyticsModels.UpdatePeriodButtonTitle.ViewModel(title: title)
		viewController?.displayPeriodButtonTitle(viewModel)
	}
	
}
