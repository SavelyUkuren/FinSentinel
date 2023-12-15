//
//  EditTransactionInteractor.swift
//  MoneyM
//
//  Created by savik on 12.12.2023.
//

import Foundation

protocol EditTransactionBusinessLogic: AnyObject {
	func loadTransaction(_ request: EditTransactionModels.LoadTransaction.Request)
	func editTransaction(_ request: EditTransactionModels.EditTransaction.Request)
}

class EditTransactionInteractor: EditTransactionBusinessLogic {
	var presenter: EditTransactionPresentLogic?
	
	func loadTransaction(_ request: EditTransactionModels.LoadTransaction.Request) {
		let response = EditTransactionModels.LoadTransaction.Response(transaction: request.transaction)
		presenter?.presentLoadTransaction(response)
	}
	
	func editTransaction(_ request: EditTransactionModels.EditTransaction.Request) {
		
		guard !request.amount.isEmpty else {
			let hasError = true
			let errorMessage = NSLocalizedString("enter_amount.error", comment: "")
			
			let response = EditTransactionModels.EditTransaction.Response(hasError: hasError,
																		   errorMessage: errorMessage)
			presenter?.presentEditTransaction(response)
			return
		}
		
		guard request.amount.isNumber else {
			let hasError = true
			let errorMessage = NSLocalizedString("amount_textfield_has_number.error", comment: "")
			
			let response = EditTransactionModels.EditTransaction.Response(hasError: hasError,
																		   errorMessage: errorMessage)
			presenter?.presentEditTransaction(response)
			return
		}
		
		let amountStr = request.amount.components(separatedBy: .whitespaces).joined()
		let amount = Int(amountStr)
		let date = request.date
		
		let model = TransactionModel()
		model.amount = amount
		model.date = date
		model.mode = request.mode
		model.categoryID = request.category?.id
		model.note = request.note
		
		let response = EditTransactionModels.EditTransaction.Response(transactionModel: model,
																	   hasError: false,
																	   errorMessage: nil)
		presenter?.presentEditTransaction(response)
	}
	
}
