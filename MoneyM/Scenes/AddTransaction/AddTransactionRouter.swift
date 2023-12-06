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
