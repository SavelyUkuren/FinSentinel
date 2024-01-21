//
//  AddTransactionRouter.swift
//  MoneyM
//
//  Created by Air on 01.12.2023.
//

import Foundation
import UIKit

protocol AddTransactionRoutingLogic: AnyObject {
	func routeToSelectCategory()
}

class AddTransactionRouter: AddTransactionRoutingLogic {

	public weak var viewController: AddTransactionViewController?

	func routeToSelectCategory() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		if let categoriesVC = storyboard.instantiateViewController(identifier: "Categories") as? CategoriesViewController {

			categoriesVC.categoryType = switch viewController?.choiceButton.selectedButton {
			case .first:
				CategoryType.expense
			case .second:
				CategoryType.income
			case .none:
				CategoryType.expense
			}

			categoriesVC.delegate = viewController

			viewController?.present(categoriesVC, animated: true)
		}

	}
}
