//
//  HomeViewController.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//

import UIKit

protocol HomeDisplayLogic {
	func displayTransactions(_ viewModel: Home.FetchTransactions.ViewModel)
	func displayFinancialSummary(_ viewModel: Home.FetchFinancialSummary.ViewModel)
	func displayRemoveTransaction(_ viewModel: Home.RemoveTransaction.ViewModel)
}

class HomeViewController: UIViewController {
	
	@IBOutlet weak var balanceAmountLabel: UILabel!
	
	@IBOutlet weak var expenseAmountLabel: UILabel!
	
	@IBOutlet weak var incomeAmountLabel: UILabel!
	
	@IBOutlet weak var transactionsTableView: UITableView!
	
	@IBOutlet weak var addTransactionButton: UIButton!
	
	@IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
	
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
		configureFontLabels()
		
		interactor?.fetchTransactions(Home.FetchTransactions.Request())
		interactor?.fetchFinancialSummary(request: Home.FetchFinancialSummary.Request())
	}
	
	private func configureTransactionsTableView() {
		transactionsTableView.delegate = self
		transactionsTableView.dataSource = self
	}
	
	private func configureFontLabels() {
		let font = CustomFonts()
		balanceAmountLabel.font = font.RoundedFont(balanceAmountLabel.font.pointSize, .bold)
		expenseAmountLabel.font = font.RoundedFont(expenseAmountLabel.font.pointSize, .semibold)
		incomeAmountLabel.font = font.RoundedFont(incomeAmountLabel.font.pointSize, .semibold)
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
	
	func displayFinancialSummary(_ viewModel: Home.FetchFinancialSummary.ViewModel) {
		balanceAmountLabel.textColor = viewModel.balanceColor
		balanceAmountLabel.text = viewModel.balance
		expenseAmountLabel.text = viewModel.expense
		incomeAmountLabel.text = viewModel.income
	}
	
	func displayRemoveTransaction(_ viewModel: Home.RemoveTransaction.ViewModel) {
		transactionsArray = viewModel.data
		transactionsTableView.reloadData()
		
		let request = Home.FetchFinancialSummary.Request()
		interactor?.fetchFinancialSummary(request: request)
	}
	
}

// MARK: - Table View Delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
		let transactionCell = (cell as! TransactionTableViewCell)
//		transactionCell.layer.cornerRadius = 0
//		
//		if numberOfRows == 1 {
//			transactionCell.roundCorner(radius: 12, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
//		} else if indexPath.row == 0 {
//			transactionCell.roundCorner(radius: 12, corners: [.topLeft, .topRight])
//		} else if indexPath.row == numberOfRows - 1 {
//			transactionCell.roundCorner(radius: 12, corners: [.bottomLeft, .bottomRight])
//		}
		
		scrollViewHeightConstraint.constant = tableView.contentSize.height
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
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		let deleteAction = UIContextualAction(style: .destructive,
											  title: "Delete") { swipeAction, view, complition in
			let transaction = self.transactionsArray[indexPath.section].transactions[indexPath.row]
			let request = Home.RemoveTransaction.Request(transaction: transaction)
			self.interactor?.removeTransaction(request: request)
		}
		
		let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
		
		return swipeAction
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
		interactor?.fetchFinancialSummary(request: Home.FetchFinancialSummary.Request())
	}
}
