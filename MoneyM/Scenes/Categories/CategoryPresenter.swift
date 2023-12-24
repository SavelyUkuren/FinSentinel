//
//  CategoryPresenter.swift
//  MoneyM
//
//  Created by Air on 06.12.2023.
//

import Foundation

protocol CategoryPresentLogic {
	func presentCategories(_ response: CategoryModels.FetchCategories.Response)
}

class CategoryPresenter: CategoryPresentLogic {

	public var viewController: CategoryDisplayLogic?

	func presentCategories(_ response: CategoryModels.FetchCategories.Response) {
		let viewModel = CategoryModels.FetchCategories.ViewModel(categories: response.categories)
		viewController?.displayCategories(viewModel)
	}
}
