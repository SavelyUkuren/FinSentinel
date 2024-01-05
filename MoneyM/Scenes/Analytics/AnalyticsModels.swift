//
//  AnalyticsModels.swift
//  MoneyM
//
//  Created by savik on 05.01.2024.
//

import Foundation
import UIKit

struct AnalyticsModels {
	
	struct CategorySummaryModel {
		let icon: UIImage
		let title: String
		let amount: String
	}
	
	struct FetchTransactionsByMonth {
		struct Request {
			let month: Int
			let year: Int
		}
		struct Response {
			let transactions: [TransactionModel]
		}
		struct ViewModel {
			let categories: [CategorySummaryModel]
		}
	}
	
}
