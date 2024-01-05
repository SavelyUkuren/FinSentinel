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
		}
		struct Response {
			let transactions: [TransactionModel]
		}
		struct ViewModel {
			let categories: [CategorySummaryModel]
		}
	}
	
}
