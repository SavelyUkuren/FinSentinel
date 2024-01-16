//
//  AnalyticsModels.swift
//  MoneyM
//
//  Created by savik on 05.01.2024.
//

import Foundation
import UIKit
import DGCharts

struct AnalyticsModels {
	
	enum TransactionType {
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
			let transactionType: TransactionType
		}
		struct Response {
			let transactions: [TransactionModel]
			let chartDataSet: BarChartDataSet
			let transactionType: TransactionType
			let period: Period
			let totalAmount: Double
			let average: Double
		}
		struct ViewModel {
			let categories: [CategorySummaryModel]
			let summary: [FinancialSummaryCellModel]
			let chartData: BarChartData
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
