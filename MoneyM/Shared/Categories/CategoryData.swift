//
//  CategoryData.swift
//  MoneyM
//
//  Created by Air on 07.11.2023.
//

import Foundation

struct CategoryData: Codable {
    var expenses: [CategoryModel]
    var incomes: [CategoryModel]
}
