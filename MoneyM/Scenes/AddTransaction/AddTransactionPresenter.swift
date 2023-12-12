//
//  AddTransactionPresenter.swift
//  MoneyM
//
//  Created by Air on 01.12.2023.
//

import Foundation

protocol AddTransactionPresentationLogic {
	func presentCreatedTransaction(_ response: AddTransactionModels.CreateTransaction.Response)
}

class AddTransactionPresenter: AddTransactionPresentationLogic {
	
	var viewController: AddTransactionDisplayLogic?
	
	init() {
		
	}
	
	func presentCreatedTransaction(_ response: AddTransactionModels.CreateTransaction.Response) {
		let viewModel = AddTransactionModels.CreateTransaction.ViewModel(transactionModel: response.transactionModel,
																		 hasError: response.hasError, errorMessage: response.errorMessage)
		viewController?.displayCreatedTransaction(viewModel)
	}
}
