//
//  HomePresenter.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//

import Foundation
import UIKit

protocol HomePresentationLogic {
	func presentTransactions(_ response: Home.FetchTransactions.Response)
	func presentFinancialSummary(_ response: Home.FetchFinancialSummary.Response)
}

// MARK: - Presentation logic
class HomePresenter: HomePresentationLogic {
	
	var viewController: HomeDisplayLogic?
	
	init() {
		
	}
	
	func presentTransactions(_ response: Home.FetchTransactions.Response) {
		var presentData: [Home.TransactionTableViewCellModel] = []
		
		response.data.forEach { data in
			let dateString = getDayAndMonth(data.date)
			let transactions = data.transactions
			
			let model = Home.TransactionTableViewCellModel(section: dateString,
														   transactions: transactions)
			
			presentData.append(model)
		}
		
		let viewModel = Home.FetchTransactions.ViewModel(data: presentData)
		viewController?.displayTransactions(viewModel)
	}
	
	func presentFinancialSummary(_ response: Home.FetchFinancialSummary.Response) {
		let currency = Settings.shared.model.currency.symbol
		let balance = "\(response.summary.balance) \(currency)"
		let expense = "\(response.summary.expense) \(currency)"
		let income = "\(response.summary.income) \(currency)"
		let balanceColor: UIColor = response.summary.balance < 0 ? .systemRed : .systemGreen
		
		let viewModel = Home.FetchFinancialSummary.ViewModel(balanceColor: balanceColor,
															 balance: balance,
															 expense: expense,
															 income: income)
		viewController?.displayFinancialSummary(viewModel)
	}
	
	private func getDayAndMonth(_ date: Date) -> String {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d MMMM"
		
		return dateFormatter.string(from: date)
	}
	
}
