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

	var presenter: AddTransactionPresentationLogic?

	init() {

	}
	
}

// MARK: - AddTransactionInteractor business logic
extension AddTransactionInteractor: AddTransactionBusinessLogic {
	
	func create(_ request: AddTransactionModels.Create.Request) {

		let amountStr = request.amount.components(separatedBy: .whitespaces).joined()

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

		let amount = Int(amountStr)
		let date = request.date

		let model = TransactionModel()
		model.amount = amount
		model.date = date
		model.mode = request.mode
		model.categoryID = request.category?.id
		model.note = request.note

		let response = AddTransactionModels.Create.Response(model: model,
																	   hasError: false,
																	   errorMessage: nil)
		presenter?.presentCreatedTransaction(response)
	}
	
}
