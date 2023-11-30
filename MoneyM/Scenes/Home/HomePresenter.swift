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
		let viewModel = Home.FetchTransactions.ViewModel(data: response.data)
		viewController?.displayTransactions(viewModel)
	}
	
}
