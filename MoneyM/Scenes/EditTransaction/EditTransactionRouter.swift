//
//  EditTransactionRouter.swift
//  MoneyM
//
//  Created by savik on 12.12.2023.
//

import Foundation
import UIKit

protocol EditTransactionRoutingLogic {
	func routeToSelectCategory()
}

class EditTransactionRouter: EditTransactionRoutingLogic {
	
	var viewController: EditTransactionViewController?
	
	func routeToSelectCategory() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(identifier: "Categories") as! CategoriesViewController
		vc.categoryType = switch viewController?.choiceButton.selectedButton {
		case .First:
			TransactionModel.Mode.Expense
		case .Second:
			TransactionModel.Mode.Income
		case .none:
			TransactionModel.Mode.Expense
		}
		
		vc.delegate = viewController
		
		viewController?.present(vc, animated: true)
	}
}
