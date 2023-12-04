//
//  AddTransactionRouter.swift
//  MoneyM
//
//  Created by Air on 01.12.2023.
//

import Foundation

protocol AddTransactionRoutingLogic {
	func routeToSelectCategory()
}

class AddTransactionRouter: AddTransactionRoutingLogic {
	
	var viewController: AddTransactionViewController?
	
	func routeToSelectCategory() {
		let selectCategoryVC = SelectCategoryViewController()
		selectCategoryVC.delegate = viewController
		
		viewController?.present(selectCategoryVC, animated: true)
	}
}
