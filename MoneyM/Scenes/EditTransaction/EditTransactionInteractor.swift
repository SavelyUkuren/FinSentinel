////
////  EditTransactionInteractor.swift
////  MoneyM
////
////  Created by savik on 12.12.2023.
////
//
//import Foundation
//
//protocol EditTransactionBusinessLogic: AnyObject {
//	func load(_ request: EditTransactionModels.Load.Request)
//	func edit(_ request: EditTransactionModels.Edit.Request)
//}
//
//class EditTransactionInteractor {
//
//	var presenter: EditTransactionPresentLogic?
//
//}
//
//// MARK: - EditTransactionInteractor business logic
//extension EditTransactionInteractor: EditTransactionBusinessLogic {
//
//	func load(_ request: EditTransactionModels.Load.Request) {
//		let response = EditTransactionModels.Load.Response(transaction: request.transaction)
//		presenter?.presentTransaction(response)
//	}
//
//	func edit(_ request: EditTransactionModels.Edit.Request) {
//
//		let amountStr = request.amount.components(separatedBy: .whitespaces).joined()
//
//		guard !amountStr.isEmpty else {
//			let hasError = true
//			let errorMessage = NSLocalizedString("enter_amount.error", comment: "")
//
//			let response = EditTransactionModels.Edit.Response(hasError: hasError,
//																		  errorMessage: errorMessage)
//			presenter?.presentEditedTransaction(response)
//			return
//		}
//
//		guard amountStr.isNumber else {
//			let hasError = true
//			let errorMessage = NSLocalizedString("amount_textfield_has_number.error", comment: "")
//
//			let response = EditTransactionModels.Edit.Response(hasError: hasError,
//																		  errorMessage: errorMessage)
//			presenter?.presentEditedTransaction(response)
//			return
//		}
//
//		let amount = Int(amountStr)
//		let date = request.date
//
////		let model = TransactionModel()
////		model.amount = amount
////		model.date = date
////		model.mode = request.mode
////		model.categoryID = request.category?.id
////		model.note = request.note
////
////		let response = EditTransactionModels.Edit.Response(model: model,
////																	  hasError: false,
////																	  errorMessage: nil)
////		presenter?.presentEditedTransaction(response)
//	}
//
//}
