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
		let amount = Int(request.amount)
		let date = request.date
		
		let model = TransactionModel()
		model.amount = amount
		model.date = date
		model.mode = request.mode
		model.categoryID = request.category?.id
		
		let response = AddTransactionModels.CreateTransaction.Response(transactionModel: model,
																	   hasError: false,
																	   errorMessage: nil)
		presenter?.presentCreatedTransaction(response)
	}
	
}
