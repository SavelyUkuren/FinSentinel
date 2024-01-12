////
////  AddTransactionPresenter.swift
////  MoneyM
////
////  Created by Air on 01.12.2023.
////
//
//import Foundation
//
//protocol AddTransactionPresentationLogic: AnyObject {
//	func presentCreatedTransaction(_ response: AddTransactionModels.Create.Response)
//}
//
//class AddTransactionPresenter {
//
//	public var viewController: AddTransactionDisplayLogic?
//
//	init() {
//
//	}
//
//}
//
//// MARK: - AddTransactionPresenter present logic
//extension AddTransactionPresenter: AddTransactionPresentationLogic {
//
//	func presentCreatedTransaction(_ response: AddTransactionModels.Create.Response) {
//		let viewModel = AddTransactionModels.Create.ViewModel(model: response.model,
//																		 hasError: response.hasError, errorMessage: response.errorMessage)
//		viewController?.displayCreatedTransaction(viewModel)
//	}
//
//}
