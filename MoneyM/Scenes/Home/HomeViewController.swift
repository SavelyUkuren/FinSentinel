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
		
		viewController.interactor = interactor
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
		
	}
	
}

// MARK: - Display logic
extension HomeViewController: HomeDisplayLogic {
	
	func displayTransactions(_ viewModel: Home.FetchTransactions.ViewModel) {
		transactionsArray = viewModel.data
	}
	
}

// MARK: - Table View Delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		transactionsArray[section].transactions.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
		
		let amount = transactionsArray[indexPath.section].transactions[indexPath.row].amount
		cell.textLabel?.text = String(amount ?? -1)
		
		return cell
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		transactionsArray.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return transactionsArray[section].section
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		50
	}
	
}
