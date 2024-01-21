//
//  FinancialSummaryCellModel.swift
//  MoneyM
//
//  Created by savik on 03.01.2024.
//

import Foundation
import UIKit

struct FinancialSummaryCellModel {
	private var currencySymbol = Settings.shared.model.currency.symbol
	
	let title: String
	
	var amountColor: UIColor? = nil
	var amountStr: String?
	
	init(title: String, amount: Double) {
		self.title = title
		
		var roundedAmount = Double(round(amount * 100) / 100)
		
		// amount may contain a minus operator if equal zero
		if roundedAmount == 0 { roundedAmount = abs(roundedAmount) }
		
		amountColor = roundedAmount < 0 ? .systemRed : .systemGreen
		amountStr = "\(roundedAmount.thousandSeparator) \(currencySymbol)"
	}
	
}
