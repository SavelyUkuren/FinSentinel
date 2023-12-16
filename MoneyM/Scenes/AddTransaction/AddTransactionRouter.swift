//
//  AddTransactionRouter.swift
//  MoneyM
//
//  Created by Air on 01.12.2023.
//

import Foundation
import UIKit

protocol AddTransactionRoutingLogic {
	func routeToSelectCategory()
}

class AddTransactionRouter: AddTransactionRoutingLogic {

	var viewController: AddTransactionViewController?

	func routeToSelectCategory() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		if let categoriesVC = storyboard.instantiateViewController(identifier: "Categories") as? CategoriesViewController {

			categoriesVC.categoryType = switch viewController?.choiceButton.selectedButton {
			case .first:
				TransactionModel.Mode.expense
			case .second:
				TransactionModel.Mode.income
			case .none:
				TransactionModel.Mode.expense
			}

			categoriesVC.delegate = viewController

			viewController?.present(categoriesVC, animated: true)
		}

	}
}
