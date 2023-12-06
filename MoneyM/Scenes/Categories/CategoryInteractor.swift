//
//  CategoryInteractor.swift
//  MoneyM
//
//  Created by Air on 06.12.2023.
//

import Foundation

protocol CategoryBusinessLogic {
	func fetchCategories(_ request: CategoryModels.FetchCategories.Request)
}

class CategoryInteractor: CategoryBusinessLogic {
	
	var presenter: CategoryPresentLogic?
	
	func fetchCategories(_ request: CategoryModels.FetchCategories.Request) {
		let categoriesManager = CategoriesManager.shared
		
		let categories: [CategoryModel]
		
		switch request.categoryType {
		case .Expense:
			categories = categoriesManager.categoriesData.expenses
		case .Income:
			categories = categoriesManager.categoriesData.incomes
		}
		
		let response = CategoryModels.FetchCategories.Response(categories: categories)
		presenter?.presentCategories(response)
	}
	
}
