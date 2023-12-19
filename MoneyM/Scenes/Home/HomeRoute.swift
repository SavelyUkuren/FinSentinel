//
//  HomeRoute.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//

import Foundation
import UIKit

protocol HomeRoutingLogic {
	func routeToAddNewTransaction()
	func routeToEditTransaction(transaction: TransactionModel)
}

class HomeRoute: HomeRoutingLogic {

	var viewController: HomeViewController?

	func routeToAddNewTransaction() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		if let addTransactionVC = storyboard.instantiateViewController(withIdentifier: "AddTransaction") as? AddTransactionViewController {
			addTransactionVC.delegate = viewController

			viewController?.present(addTransactionVC, animated: true)
		}
	}

	func routeToEditTransaction(transaction: TransactionModel) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		if let editTransactionVC = storyboard.instantiateViewController(withIdentifier: "EditTransaction") as? EditTransactionViewController {

			editTransactionVC.transaction = transaction
			editTransactionVC.delegate = viewController

			viewController?.present(editTransactionVC, animated: true)
		}
	}

}
