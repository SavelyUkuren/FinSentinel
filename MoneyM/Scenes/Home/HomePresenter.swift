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
		var data = [Home.TransactionTableViewCellModel(section: "Test", transactions: response.data)]
		let viewModel = Home.FetchTransactions.ViewModel(data: data)
		viewController?.displayTransactions(viewModel)
	}
	
}
