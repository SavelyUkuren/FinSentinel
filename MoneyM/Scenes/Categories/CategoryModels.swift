//
//  CategoryModels.swift
//  MoneyM
//
//  Created by Air on 06.12.2023.
//

import Foundation

class CategoryModels {

	struct FetchCategories {
		struct Request {
			var categoryType: TransactionModel.Mode
		}
		struct Response {
			var categories: [CategoryModel]
		}
		struct ViewModel {
			var categories: [CategoryModel]
		}
	}

}
