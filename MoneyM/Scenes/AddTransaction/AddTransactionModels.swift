//
//  AddTransactionModel.swift
//  MoneyM
//
//  Created by Air on 01.12.2023.
//

import Foundation

struct AddTransactionModels {
	
	struct CreateTransaction {
		struct Request {
			var amount: String
			var date: Date
		}
		struct Response {
			var transactionModel: TransactionModel
			var hasError: Bool
			var errorMessage: String?
		}
		struct ViewModel {
			var transactionModel: TransactionModel
			var hasError: Bool
			var errorMessage: String?
		}
	}
	
}
