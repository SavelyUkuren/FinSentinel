//
//  FinancialSummaryBeautifier.swift
//  MoneyM
//
//  Created by savik on 13.01.2024.
//

import Foundation
import UIKit

class FinancialSummaryBeautifier {
	var financialSummary: FinancialSummaryModel? {
		didSet {
			if let unwrappedFinancialSummary = financialSummary {
				self.expense = beauty(unwrappedFinancialSummary.expense)
				self.income = beauty(unwrappedFinancialSummary.income)
				self.startingBalance = beauty(unwrappedFinancialSummary.startingBalance)
				self.balance = beauty(unwrappedFinancialSummary.balance)
				
				self.balanceColor = unwrappedFinancialSummary.balance < 0 ? .systemRed : .systemGreen
			}
		}
	}
	
	var expense: String?
	
	var income: String?
	
	var startingBalance: String?
	
	var balance: String?
	
	var expenseColor: UIColor = .systemRed
	
	var incomeColor: UIColor = .systemGreen
	
	var startingBalanceColor: UIColor = .systemGreen
	
	var balanceColor: UIColor = .systemRed
	
	init() {
		
	}
	
	func beauty(_ amount: Double) -> String {

		let currencySymbol = Settings.shared.model.currency.symbol
		
		if abs(amount) == 0 { return "0 \(currencySymbol)" }
		
		let amountOperator = amount < 0 ? "-" : "+"
		let amountStr = abs(amount).thousandSeparator
		
		return "\(amountOperator)\(amountStr) \(currencySymbol)"
	}
}
