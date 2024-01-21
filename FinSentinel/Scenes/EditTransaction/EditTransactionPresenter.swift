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
		
		var categoryModel: CategoryProtocol = categoryManager.defaultCategory
		if let foundedCategoryModel = categoryManager.findCategory(id: response.transaction.categoryID ?? 0) {
			categoryModel = foundedCategoryModel
		}
		
//		if let categoryModel = categoryManager.findCategoryBy(id: response.transaction.categoryID ?? 0) {
//			category = categoryModel
//		} else if let subcategoryModel = categoryManager.findSubcategoryBy(id: response.transaction.categoryID ?? 0) {
//			category.title = subcategoryModel.title
//			category.id = subcategoryModel.id
//			category.icon = subcategoryModel.icon
//		}

		let amount = String(response.transaction.amount.thousandSeparator)
		let mode = response.transaction.transactionType
		let date = response.transaction.dateOfCreation
		let note = response.transaction.note ?? ""

		let viewModel = EditTransactionModels.Load.ViewModel(amount: amount,
															 transactionType: mode,
															 category: categoryModel,
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
