//
//  EditTransactionModels.swift
//  MoneyM
//
//  Created by savik on 12.12.2023.
//

import Foundation

struct EditTransactionModels {

	struct Load {
		struct Request {
			let transaction: TransactionModel
		}
		struct Response {
			let transaction: TransactionModel
		}
		struct ViewModel {
			let amount: String
			let transactionType: TransactionType
			let category: CategoryProtocol
			let dateOfCreation: Date
			let note: String
		}
	}

	struct Edit {
		struct Request {
			let amount: String
			let dateOfCreation: Date
			let category: CategoryProtocol?
			let transactionType: TransactionType
			let note: String?
		}
		struct Response {
			var model: TransactionModel?
			let hasError: Bool
			let errorMessage: String?
		}
		struct ViewModel {
			var model: TransactionModel?
			let hasError: Bool
			let errorMessage: String?
		}
	}
}
