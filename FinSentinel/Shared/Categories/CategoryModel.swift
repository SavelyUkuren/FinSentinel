//
//  CategoryModel.swift
//  MoneyM
//
//  Created by Air on 16.09.2023.
//

import Foundation

struct CategoryModel: CategoryProtocol {
    var id: Int
    var title: String
	var icon: String
	var subcategories: [SubcategoryModel]?
}
