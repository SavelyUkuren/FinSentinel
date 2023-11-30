//
//  HomeViewController.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//

import UIKit

protocol HomeDisplayLogic {
	func displayTransactions(_ viewModel: Home.FetchTransactions.ViewModel)
}

class HomeViewController: UIViewController {
	
	@IBOutlet weak var balanceAmountLabel: UILabel!
	
	@IBOutlet weak var expenseAmountLabel: UILabel!
	
	@IBOutlet weak var incomeAmountLabel: UILabel!
	
	@IBOutlet weak var transactionsTableView: UITableView!
	
	@IBOutlet weak var addTransactionButton: UIButton!
	
	var interactor: HomeBusinessLogic?
	
	private var transactionsArray: [TransactionModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

		setup()
		interactor?.fetchTransactions(Home.FetchTransactions.Request())
		
		print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
    }
    
	private func setup() {
		let viewController = self
		let interactor = HomeInteractor()
		let presenter = HomePresenter()
		
		viewController.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = viewController
	}
	
	// MARK: Actions
	@IBAction func addTransactionButtonClicked(_ sender: Any) {
		
	}
	
}

// MARK: - Display logic
extension HomeViewController: HomeDisplayLogic {
	
	func displayTransactions(_ viewModel: Home.FetchTransactions.ViewModel) {
		transactionsArray = viewModel.data
	}
	
}
