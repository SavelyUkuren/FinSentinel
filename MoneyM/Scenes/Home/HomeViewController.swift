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
	func displayAlertDatePicker(_ viewModel: Home.AlertDatePicker.ViewModel)
	func displayDatePickerButton(_ viewModel: Home.DatePickerButton.ViewModel)
}

class HomeViewController: UIViewController {

	@IBOutlet weak var balanceAmountLabel: UILabel!

	@IBOutlet weak var expenseAmountLabel: UILabel!

	@IBOutlet weak var incomeAmountLabel: UILabel!

	@IBOutlet weak var transactionsTableView: UITableView!

	@IBOutlet weak var addTransactionButton: UIButton!

	@IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!

	@IBOutlet weak var datePickerButton: UIButton!

	public var interactor: HomeBusinessLogic?

	public var router: HomeRoutingLogic?

	private(set) var transactionsArray: [Home.TransactionTableViewCellModel] = []

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
		interactor?.fetchFinancialSummary(Home.FetchFinancialSummary.Request())

		addNotificationObservers()

		interactor?.updateDatePickerButton(Home.DatePickerButton.Request())
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

	@objc
	private func changeCurrency() {
		interactor?.fetchTransactions(Home.FetchTransactions.Request(month: 12, year: 2023))
		interactor?.fetchFinancialSummary(Home.FetchFinancialSummary.Request())
	}

	// MARK: Actions
	@IBAction func addTransactionButtonClicked(_ sender: Any) {
		router?.routeToAddNewTransaction()
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

		let action = { (month: Int, year: Int) in
			let request = Home.FetchTransactions.Request(month: month, year: year)
			self.interactor?.fetchTransactions(request)

			self.interactor?.fetchFinancialSummary(Home.FetchFinancialSummary.Request())
			self.interactor?.updateDatePickerButton(Home.DatePickerButton.Request())
		}

		let request = Home.AlertDatePicker.Request(action: action)
		interactor?.showAlertDatePicker(request)
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
		interactor?.fetchFinancialSummary(request)
	}

	func displayAlertEditStartingBalance(_ viewModel: Home.AlertEditStartingBalance.ViewModel) {
		present(viewModel.alert, animated: true)
	}

	func displayAlertDatePicker(_ viewModel: Home.AlertDatePicker.ViewModel) {
		present(viewModel.alert, animated: true)
	}

	func displayDatePickerButton(_ viewModel: Home.DatePickerButton.ViewModel) {
		datePickerButton.setTitle(viewModel.title, for: .normal)
	}

}

// MARK: - Add transaction delegate
extension HomeViewController: AddTransactionDelegate {
	func transactionCreated(_ transaction: TransactionModel) {
		let request = Home.AddTransaction.Request(transaction: transaction)
		interactor?.addTransaction(request)
		interactor?.fetchFinancialSummary(Home.FetchFinancialSummary.Request())
	}
}

// MARK: - EditTransaction delegate
extension HomeViewController: EditTransactionDelegate {
	func didEditTransaction(_ newTransaction: TransactionModel) {
		let request = Home.EditTransaction.Request(transaction: newTransaction)
		interactor?.editTransaction(request)
		interactor?.fetchFinancialSummary(Home.FetchFinancialSummary.Request())
	}
}
