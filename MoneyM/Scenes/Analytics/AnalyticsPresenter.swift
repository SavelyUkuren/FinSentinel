//
//  AnalyticsPresenter.swift
//  MoneyM
//
//  Created by savik on 05.01.2024.
//

import Foundation
import UIKit

protocol AnalyticsPresentLogic {
	func presentAnalyticsData(_ response: AnalyticsModels.FetchTransactions.Response)
}

class AnalyticsPresenter {
	
	public var viewController: AnalyticsDisplayLogic?
	
	private func calculateTotalSumOfTransactions(transactions: [TransactionModel]) -> Int {
		return transactions.reduce(into: 0) { amount, transaction in
			amount += transaction.amount
		}
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
		
		let viewModel = AnalyticsModels.FetchTransactions.ViewModel(categories: categories)
		viewController?.displayAnalyticsData(viewModel)
	}
}
