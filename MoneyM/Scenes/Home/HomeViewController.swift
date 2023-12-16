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
	func displayAlertEditStartingBalance(_ viewModel: Home.AlertEditStartingBalance.ViewModel)
}

class HomeViewController: UIViewController {

	@IBOutlet weak var balanceAmountLabel: UILabel!

	@IBOutlet weak var expenseAmountLabel: UILabel!

	@IBOutlet weak var incomeAmountLabel: UILabel!

	@IBOutlet weak var transactionsTableView: UITableView!

	@IBOutlet weak var addTransactionButton: UIButton!

	@IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!

	@IBOutlet weak var datePickerButton: UIButton!

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

		interactor?.fetchTransactions(Home.FetchTransactions.Request(month: 12, year: 2023))
		interactor?.fetchFinancialSummary(request: Home.FetchFinancialSummary.Request())

		addNotificationObservers()

		configureDatePickerButton()
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

	private func configureDatePickerButton() {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMMM Y"
		
		let title = formatter.string(from: .now)
		datePickerButton.setTitle(title, for: .normal)
	}

	private func addNotificationObservers() {
		// Currency changed
		NotificationCenter.default.addObserver(self, selector: #selector(changeCurrency),
											   name: Notifications.Currency, object: nil)
	}

	private func showDatePicker() {
		let datePickerVC = UIViewController()
		let pickerView = MonthYearWheelPicker()
		pickerView.minimumDate = Date(timeIntervalSince1970: 0)
		pickerView.maximumDate = .now

		datePickerVC.view = pickerView

		let alert = UIAlertController(title: "Select date", message: nil, preferredStyle: .actionSheet)
		alert.setValue(datePickerVC, forKey: "contentViewController")

		let selectAction = UIAlertAction(title: "Select", style: .default) { _ in
			let request = Home.FetchTransactions.Request(month: pickerView.month, year: pickerView.year)
			self.interactor?.fetchTransactions(request)
		}
		alert.addAction(selectAction)

		present(alert, animated: true)
	}

	@objc
	private func changeCurrency() {
		interactor?.fetchTransactions(Home.FetchTransactions.Request(month: 12, year: 2023))
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
		let action = { (newBalance: String) -> Void in
			let request = Home.EditStartingBalance.Request(newBalance: newBalance)
			self.interactor?.editStartingBalance(request)
		}

		let request = Home.AlertEditStartingBalance.Request(action: action)
		interactor?.showAlertEditStartingBalance(request)
	}

	@IBAction func selectDateButtonClicked(_ sender: Any) {
		showDatePicker()
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
	
	func displayAlertEditStartingBalance(_ viewModel: Home.AlertEditStartingBalance.ViewModel) {
		present(viewModel.alert, animated: true)
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
