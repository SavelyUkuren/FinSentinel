//
//  AddTransactionInteractor.swift
//  MoneyM
//
//  Created by Air on 01.12.2023.
//

import Foundation

protocol AddTransactionBusinessLogic: AnyObject {
	func create(_ request: AddTransactionModels.Create.Request)
}

class AddTransactionInteractor {

	public var presenter: AddTransactionPresentationLogic?

	init() {

	}

}

// MARK: - AddTransactionInteractor business logic
extension AddTransactionInteractor: AddTransactionBusinessLogic {

	func create(_ request: AddTransactionModels.Create.Request) {

		let amountStr = request.amount.components(separatedBy: .whitespaces)
			.joined().replaceCommaToDot

		guard !amountStr.isEmpty else {
			let hasError = true
			let errorMessage = NSLocalizedString("enter_amount.error", comment: "")

			let response = AddTransactionModels.Create.Response(hasError: hasError,
																		   errorMessage: errorMessage)
			presenter?.presentCreatedTransaction(response)
			return
		}

		guard amountStr.isNumber else {
			let hasError = true
			let errorMessage = NSLocalizedString("amount_textfield_has_number.error", comment: "")

			let response = AddTransactionModels.Create.Response(hasError: hasError,
																		   errorMessage: errorMessage)
			presenter?.presentCreatedTransaction(response)
			return
		}

		let amount = Double(amountStr) ?? 0
		let date = request.date

		var model = TransactionModel()
		model.amount = amount
		model.dateOfCreation = date
		model.transactionType = request.transactionType
		model.categoryID = request.category?.id
		model.note = request.note

		let response = AddTransactionModels.Create.Response(model: model,
																	   hasError: false,
																	   errorMessage: nil)
		presenter?.presentCreatedTransaction(response)
	}

}
