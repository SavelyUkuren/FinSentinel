//
//  EditTransactionPresenter.swift
//  MoneyM
//
//  Created by savik on 12.12.2023.
//

import Foundation

protocol EditTransactionPresentLogic {
	func presentLoadTransaction(_ response: EditTransactionModels.LoadTransaction.Response)
	func presentEditTransaction(_ response: EditTransactionModels.EditTransaction.Response)
}

class EditTransactionPresenter: EditTransactionPresentLogic {
	
	var viewController: EditTransactionViewController?
	
	func presentLoadTransaction(_ response: EditTransactionModels.LoadTransaction.Response) {
		let categoryManager = CategoriesManager.shared
		
		let amount = String(response.transaction.amount.thousandSeparator)
		let mode = response.transaction.mode ?? .Expense
		let category = categoryManager.findCategoryBy(id: response.transaction.categoryID ?? 0) ?? CategoriesManager.shared.defaultCategory
		let date = response.transaction.date!
		let note = response.transaction.note ?? ""
		
		let viewModel = EditTransactionModels.LoadTransaction.ViewModel(amount: amount,
																		mode: mode,
																		category: category,
																		date: date,
																		note: note)
		viewController?.displayLoadTransaction(viewModel)
	}
	
	func presentEditTransaction(_ response: EditTransactionModels.EditTransaction.Response) {
		let viewModel = EditTransactionModels.EditTransaction.ViewModel(transactionModel: response.transactionModel,
																		 hasError: response.hasError, errorMessage: response.errorMessage)
		viewController?.displayEditTransaction(viewModel)
	}
}
