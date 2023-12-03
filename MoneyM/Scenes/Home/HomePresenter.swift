//
//  HomePresenter.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//

import Foundation

protocol HomePresentationLogic {
	func presentTransactions(_ response: Home.FetchTransactions.Response)
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
	
	private func getDayAndMonth(_ date: Date) -> String {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d MMMM"
		
		return dateFormatter.string(from: date)
	}
	
}
