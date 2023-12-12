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
	
	var viewController: HomeViewController?
	
	func routeToAddNewTransaction() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "AddTransaction") as? AddTransactionViewController
		vc?.delegate = viewController
		
		viewController?.present(vc!, animated: true)
	}
	
	func routeToEditTransaction(transaction: TransactionModel) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "EditTransaction") as? EditTransactionViewController
		
		vc?.transaction = transaction
		vc?.delegate = viewController
		
		viewController?.present(vc!, animated: true)
	}
	
	func routeToSettings() {
		let storyboard = UIStoryboard(name: "Settings", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "Settings") as? UISplitViewController
//		vc?.modalPresentationStyle = .overFullScreen
		
		viewController?.present(vc!, animated: true)
	}
	
}
