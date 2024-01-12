//
//  FinancialSummary.swift
//  MoneyM
//
//  Created by Air on 01.11.2023.
//

import Foundation

struct FinancialSummaryModel {
	var startingBalance: Int = 0
    var expense: Int = 0
    var income: Int = 0
	var balance: Int {
		startingBalance + income + expense
	}
}
