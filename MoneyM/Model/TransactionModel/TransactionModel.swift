//
//  TransactionModel.swift
//  MoneyM
//
//  Created by Air on 03.09.2023.
//

import Foundation
import UIKit


class TransactionModel {
    
    enum Mode: Int {
        case Expense, Income
    }
    var id: Int!
    var date: Date!
    var amount: Int!
    var mode: Mode!
    var category: CategoryModel!
    
}
