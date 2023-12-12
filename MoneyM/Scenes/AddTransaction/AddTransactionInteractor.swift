//
//  AddTransactionInteractor.swift
//  MoneyM
//
//  Created by Air on 01.12.2023.
//

import Foundation

protocol AddTransactionBusinessLogic: AnyObject {
	func createTransaction(_ request: AddTransactionModels.CreateTransaction.Request)
}

class AddTransactionInteractor: AddTransactionBusinessLogic {
	
	var presenter: AddTransactionPresentationLogic?
	
	init() {
		
	}
	
	func createTransaction(_ request: AddTransactionModels.CreateTransaction.Request) {
		let amountStr = request.amount.components(separatedBy: .whitespaces).joined()
		let amount = Int(amountStr)
		let date = request.date
		
		let model = TransactionModel()
		model.amount = amount
		model.date = date
		model.mode = request.mode
		model.categoryID = request.category?.id
		model.note = request.note
		
		let response = AddTransactionModels.CreateTransaction.Response(transactionModel: model,
																	   hasError: false,
																	   errorMessage: nil)
		presenter?.presentCreatedTransaction(response)
	}
	
}
