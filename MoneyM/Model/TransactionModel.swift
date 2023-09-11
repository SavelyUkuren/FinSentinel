//
//  TransactionModel.swift
//  MoneyM
//
//  Created by Air on 03.09.2023.
//

import Foundation



class TransactionModel {
    
    enum Mode: Int {
        case Expense, Income
    }
    var id: Int!
    var date: Date!
    var amount: String!
    var mode: Mode!
    var category: String!
    
}
