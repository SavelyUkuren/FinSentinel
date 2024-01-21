//
//  TransactionModel.swift
//  MoneyM
//
//  Created by Air on 03.09.2023.
//

import Foundation
import UIKit

struct TransactionModel: Identifiable {

	var id = UUID()
	
	var amount: Double = 0
	var dateOfCreation = Date()
	var transactionType: TransactionType = .expense
	var categoryID: Int?
	var note: String?

}
