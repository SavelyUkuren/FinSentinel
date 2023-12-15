//
//  EditTransactionModels.swift
//  MoneyM
//
//  Created by savik on 12.12.2023.
//

import Foundation

struct EditTransactionModels {
	
	struct LoadTransaction {
		struct Request {
			let transaction: TransactionModel
		}
		struct Response {
			let transaction: TransactionModel
		}
		struct ViewModel {
			let amount: String
			let mode: TransactionModel.Mode
			let category: CategoryModel
			let date: Date
			let note: String
		}
	}
	
	
	struct EditTransaction {
		struct Request {
			var amount: String
			var date: Date
			var category: CategoryModel?
			var mode: TransactionModel.Mode
			var note: String?
		}
		struct Response {
			var transactionModel: TransactionModel?
			var hasError: Bool
			var errorMessage: String?
		}
		struct ViewModel {
			var transactionModel: TransactionModel?
			var hasError: Bool
			var errorMessage: String?
		}
	}
}
