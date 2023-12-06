//
//  FinancialSummary.swift
//  MoneyM
//
//  Created by Air on 01.11.2023.
//

import Foundation

class FinancialSummary {
    var expense: Int = 0
    var income: Int = 0
	var balance: Int  {
		get {
			income + expense
		}
	}
}
