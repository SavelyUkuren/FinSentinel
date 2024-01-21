//
//  HomeModels.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//

import Foundation
import UIKit

struct Home {

	struct FetchTransactions {
		struct Request {
			let month: Int
			let year: Int
		}
		struct Response {
			var transactions: [TransactionModel]
		}
		struct ViewModel {
			var data: [TransactionTableViewCellModel]
		}
	}

	struct AddTransaction {
		struct Request {
			let transaction: TransactionModel
		}
		struct Response {
			var transactions: [TransactionModel]
		}
		struct ViewModel {
			var data: [TransactionTableViewCellModel]
		}
	}

	struct EditTransaction {
		struct Request {
			let transaction: TransactionModel
		}
		struct Response {
			var transactions: [TransactionModel]
		}
		struct ViewModel {
			var data: [TransactionTableViewCellModel]
		}
	}

	struct EditStartingBalance {
		struct Request {
			let newBalance: String
		}
		struct Response {
			let financialSummary: FinancialSummaryModel
		}
		struct ViewModel {
			let startingBalance: FinancialSummaryCellModel
			let balance: FinancialSummaryCellModel
			let expense: FinancialSummaryCellModel
			let income: FinancialSummaryCellModel
		}
	}

	struct FetchFinancialSummary {
		struct Request {

		}
		struct Response {
			var summary: FinancialSummaryModel
		}
		struct ViewModel {
			let startingBalance: FinancialSummaryCellModel
			let balance: FinancialSummaryCellModel
			let expense: FinancialSummaryCellModel
			let income: FinancialSummaryCellModel
		}
	}

	struct RemoveTransaction {
		struct Request {
			var transaction: TransactionModel
		}
		struct Response {
			var transactions: [TransactionModel]
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

	struct DatePickerButton {
		struct Request {

		}
		struct Response {
			let month: Int
			let year: Int
		}
		struct ViewModel {
			let title: String
		}
	}
	
}
