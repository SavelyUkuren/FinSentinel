//
//  EditTransactionRouter.swift
//  MoneyM
//
//  Created by savik on 12.12.2023.
//

import Foundation
import UIKit

protocol EditTransactionRoutingLogic: AnyObject {
	func routeToSelectCategory()
}

class EditTransactionRouter: EditTransactionRoutingLogic {

	var viewController: EditTransactionViewController?

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
