//
//  AnalyticsModels.swift
//  MoneyM
//
//  Created by savik on 05.01.2024.
//

import Foundation
import UIKit

struct AnalyticsModels {
	
	enum Mode {
		case expense, income
	}
	
	enum Period {
		case month, year, all
	}
	
	struct CategorySummaryModel {
		let icon: UIImage
		let title: String
		let amount: String
	}
	
	struct FetchTransactions {
		struct Request {
			let month: Int
			let year: Int
			let period: Period
			let mode: Mode
		}
		struct Response {
			let transactions: [TransactionModel]
			let mode: Mode
			let totalAmount: Int
		}
		struct ViewModel {
			let categories: [CategorySummaryModel]
			let summary: [FinancialSummaryCellModel]
		}
	}
	
	struct ShowMonthYearWheel {
		struct Request {
			let action: (_ month: Int, _ year: Int) -> ()
		}
		struct Response {
			let action: (_ month: Int, _ year: Int) -> ()
		}
		struct ViewModel {
			let alert: UIAlertController
		}
	}
	
	struct ShowYearsWheel {
		struct Request {
			let action: (_ year: Int) -> ()
		}
		struct Response {
			let action: (_ year: Int) -> ()
		}
		struct ViewModel {
			let alert: UIAlertController
		}
	}
	
}
