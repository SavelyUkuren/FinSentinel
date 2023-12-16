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

		addNotificationObservers()
	}

	private func configureTransactionsTableView() {
		transactionsTableView.delegate = self
		transactionsTableView.dataSource = self
	}

	private func configureFontLabels() {
		let font = CustomFonts()
		balanceAmountLabel.font = font.roundedFont(balanceAmountLabel.font.pointSize, .bold)
		expenseAmountLabel.font = font.roundedFont(expenseAmountLabel.font.pointSize, .semibold)
		incomeAmountLabel.font = font.roundedFont(incomeAmountLabel.font.pointSize, .semibold)
	}

	private func addNotificationObservers() {
		// Currency changed
		NotificationCenter.default.addObserver(self, selector: #selector(changeCurrency),
											   name: Notifications.Currency, object: nil)
	}

	private func showEditBalanceAlert() {
		let alert = UIAlertController(title: "Edit starting balance",
									  message: nil,
									  preferredStyle: .alert)

		alert.addTextField { textField in
			textField.placeholder = NSLocalizedString("balance.title", comment: "")
			textField.keyboardType = .decimalPad
		}

		alert.addAction(UIAlertAction(title: NSLocalizedString("edit.title", comment: ""),
									  style: .default,
									  handler: { _ in
			let newBalance = alert.textFields![0].text!
			let request = Home.EditStartingBalance.Request(newBalance: newBalance)
			self.interactor?.editStartingBalance(request)
		}))

		present(alert, animated: true)
	}

	@objc
	private func changeCurrency() {
		interactor?.fetchTransactions(Home.FetchTransactions.Request())
		interactor?.fetchFinancialSummary(request: Home.FetchFinancialSummary.Request())
	}

	// MARK: Actions
	@IBAction func addTransactionButtonClicked(_ sender: Any) {
		router?.routeToAddNewTransaction()
	}

	@IBAction func settingsButtonClicked(_ sender: Any) {
		router?.routeToSettings()
	}

	@IBAction func balanceButtonClicked(_ sender: Any) {
		showEditBalanceAlert()
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
		scrollViewHeightConstraint.constant = tableView.contentSize.height
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		transactionsArray[section].transactions.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let transaction = transactionsArray[indexPath.section].transactions[indexPath.row]
		let cell: UITableViewCell?

		if transaction.note.isEmpty {
			cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell")
		} else {
			cell = tableView.dequeueReusableCell(withIdentifier: "cellWithNote")
		}

		if let defaultCell = cell as? TransactionTableViewCell {
			defaultCell.loadTransaction(transaction: transaction)
		} else if let cellWithNote = cell as? TransactionTableViewCellNote {
			cellWithNote.loadTransaction(transaction: transaction)
		}

		return cell ?? UITableViewCell()
	}

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let deleteAction = UIContextualAction(style: .destructive,
											  title: NSLocalizedString("delete.title", comment: "")) { _, _, _ in
			let transaction = self.transactionsArray[indexPath.section].transactions[indexPath.row]
			let request = Home.RemoveTransaction.Request(transaction: transaction)
			self.interactor?.removeTransaction(request: request)
		}

		let editAction = UIContextualAction(style: .normal,
											title: NSLocalizedString("edit.title", comment: "")) { _, _, _ in
			let transaction = self.transactionsArray[indexPath.section].transactions[indexPath.row]
			self.router?.routeToEditTransaction(transaction: transaction)
		}
		editAction.backgroundColor = .systemBlue

		let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction, editAction])

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

// MARK: - EditTransaction delegate
extension HomeViewController: EditTransactionDelegate {
	func didEditTransaction(_ newTransaction: TransactionModel) {
		let request = Home.EditTransaction.Request(transaction: newTransaction)
		interactor?.editTransaction(request)
		interactor?.fetchFinancialSummary(request: Home.FetchFinancialSummary.Request())
	}
}
