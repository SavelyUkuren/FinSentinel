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
		let amount = Int(request.amount)
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
