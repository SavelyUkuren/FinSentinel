//
//  EditTransactionPresenter.swift
//  MoneyM
//
//  Created by savik on 12.12.2023.
//

import Foundation

protocol EditTransactionPresentLogic {
	func presentTransaction(_ response: EditTransactionModels.Load.Response)
	func presentEditedTransaction(_ response: EditTransactionModels.Edit.Response)
}

class EditTransactionPresenter {

	var viewController: EditTransactionViewController?

}

// MARK: - EditTransactionPresenter present logic
extension EditTransactionPresenter: EditTransactionPresentLogic {

	func presentTransaction(_ response: EditTransactionModels.Load.Response) {
		let categoryManager = CategoriesManager.shared

		let amount = String(response.transaction.amount.thousandSeparator)
		let mode = response.transaction.transactionType
		let category = categoryManager.findCategoryBy(id: response.transaction.categoryID ?? 0) ?? CategoriesManager.shared.defaultCategory
		let date = response.transaction.dateOfCreation
		let note = response.transaction.note ?? ""

		let viewModel = EditTransactionModels.Load.ViewModel(amount: amount,
															 transactionType: mode,
															 category: category,
															 dateOfCreation: date,
															 note: note)
		viewController?.displayTransaction(viewModel)
	}

	func presentEditedTransaction(_ response: EditTransactionModels.Edit.Response) {
		let viewModel = EditTransactionModels.Edit.ViewModel(model: response.model,
																		 hasError: response.hasError, errorMessage: response.errorMessage)
		viewController?.displayEditedTransaction(viewModel)
	}

}
