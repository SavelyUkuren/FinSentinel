//
//  HomeModels.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//

import Foundation
import UIKit

struct Home {

	struct TransactionTableViewCellModel {
		var section: String
		var transactions: [TransactionModel]
	}

	struct FetchTransactions {
		struct Request {
			let month: Int
			let year: Int
		}
		struct Response {
			var data: [TransactionData]
		}
		struct ViewModel {
			var data: [TransactionTableViewCellModel]
		}
	}

	struct AddTransaction {
		struct Request {
			let transaction: TransactionModel
		}
	}

	struct EditTransaction {
		struct Request {
			let transaction: TransactionModel
		}
	}

	struct EditStartingBalance {
		struct Request {
			let newBalance: String
		}
	}

	struct FetchFinancialSummary {
		struct Request {

		}
		struct Response {
			var summary: FinancialSummary
		}
		struct ViewModel {
			var balanceColor: UIColor
			var balance: String
			var expense: String
			var income: String
		}
	}

	struct RemoveTransaction {
		struct Request {
			var transaction: TransactionModel
		}
		struct Response {
			var data: [TransactionData]
		}
		struct ViewModel {
			var data: [TransactionTableViewCellModel]
		}
	}

	struct AlertEditStartingBalance {
		struct Request {
			let action: (_ newBalance: String) -> Void
		}
		struct Response {
			let action: (_ newBalance: String) -> Void
		}
		struct ViewModel {
			let alert: UIAlertController
		}
	}

	struct AlertDatePicker {
		struct Request {
			let action: (_ month: Int, _ year: Int) -> Void
		}
		struct Response {
			let action: (_ month: Int, _ year: Int) -> Void
		}
		struct ViewModel {
			let alert: UIAlertController
		}
	}

}
