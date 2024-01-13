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
	func routeToSettings()
}

class HomeRoute: HomeRoutingLogic {

	public var viewController: HomeViewController?

	func routeToAddNewTransaction() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let addTransactionVC = storyboard.instantiateViewController(identifier: "TransactionViewer") { coder in
			return AddTransactionViewController(coder: coder)
		}

		addTransactionVC.delegate = viewController

		viewController?.present(addTransactionVC, animated: true)
	}

	func routeToEditTransaction(transaction: TransactionModel) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let editTransactionVC = storyboard.instantiateViewController(identifier: "TransactionViewer") { coder in
			return EditTransactionViewController(coder: coder)
		}

		editTransactionVC.transaction = transaction
		editTransactionVC.delegate = viewController

		viewController?.present(editTransactionVC, animated: true)
	}

	func routeToSettings() {
		let storyboard = UIStoryboard(name: "Settings", bundle: nil)
		if let settingsVC = storyboard.instantiateViewController(withIdentifier: "Settings") as? SettingsSplitViewController {
			viewController?.present(settingsVC, animated: true)
		}
	}
	
}
