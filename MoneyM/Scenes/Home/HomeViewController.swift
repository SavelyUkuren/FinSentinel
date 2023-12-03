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
	
	var router: HomeRoutingLogic?
	
	private var transactionsArray: [Home.TransactionTableViewCellModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

		setup()
		configurations()
		
    }
    
	private func setup() {
		let viewController = self
		let interactor = HomeInteractor()
		let presenter = HomePresenter()
		let router = HomeRoute()
		
		router.viewController = viewController
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
	}
	
	private func configurations() {
		configureTransactionsTableView()
		
		interactor?.fetchTransactions(Home.FetchTransactions.Request())
	}
	
	private func configureTransactionsTableView() {
		transactionsTableView.delegate = self
		transactionsTableView.dataSource = self
	}
	
	// MARK: Actions
	@IBAction func addTransactionButtonClicked(_ sender: Any) {
		router?.routeToAddNewTransaction()
	}
	
}

// MARK: - Display logic
extension HomeViewController: HomeDisplayLogic {
	
	func displayTransactions(_ viewModel: Home.FetchTransactions.ViewModel) {
		transactionsArray = viewModel.data
		transactionsTableView.reloadData()
	}
	
}

// MARK: - Table View Delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
		let transactionCell = (cell as! TransactionTableViewCell)
		transactionCell.layer.cornerRadius = 0
		
		if numberOfRows == 1 {
			transactionCell.roundCorner(radius: 12, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
		} else if indexPath.row == 0 {
			transactionCell.roundCorner(radius: 12, corners: [.topLeft, .topRight])
		} else if indexPath.row == numberOfRows - 1 {
			transactionCell.roundCorner(radius: 12, corners: [.bottomLeft, .bottomRight])
		}
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		transactionsArray[section].transactions.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TransactionTableViewCell
		
		let transaction = transactionsArray[indexPath.section].transactions[indexPath.row]
		cell.loadTransaction(transaction: transaction)
		
		return cell
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		transactionsArray.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return transactionsArray[section].section
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		20
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		65
	}
}

// MARK: - Add transaction delegate
extension HomeViewController: AddTransactionDelegate {
	func transactionCreated(_ transaction: TransactionModel) {
		let request = Home.AddTransaction.Request(transaction: transaction)
		interactor?.addTransaction(request: request)
	}
}
