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
	
}
