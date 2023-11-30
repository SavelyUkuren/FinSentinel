//
//  HomeModels.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//

import Foundation

struct Home {
	
	struct TransactionTableViewCellModel {
		var section: String
		var transactions: [TransactionModel]
	}
	
	struct FetchTransactions {
		struct Request {
			
		}
		struct Response {
			var data: [TransactionModel]
		}
		struct ViewModel {
			var data: [TransactionTableViewCellModel]
		}
	}
	
	
	
}
