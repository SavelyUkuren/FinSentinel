//
//  TransactionModel.swift
//  MoneyM
//
//  Created by Air on 03.09.2023.
//

import Foundation
import UIKit


class TransactionModel: Identifiable {
	
	enum Mode: Int {
		case Expense, Income
	}
	var id = UUID()
	var date: Date!
	var amount: Int!
	var mode: Mode!
	var categoryID: Int!
	var note: String!
	
}
