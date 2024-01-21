//
//  FinancialSummary.swift
//  MoneyM
//
//  Created by Air on 01.11.2023.
//

import Foundation

struct FinancialSummaryModel {
	var startingBalance: Double = 0
    var expense: Double = 0
    var income: Double = 0
	var balance: Double {
		startingBalance + income + expense
	}
}
