//
//  HomeViewController.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//

import UIKit

protocol HomeDisplayLogic {
	func displayTransactions(_ viewModel: Home.FetchTransactions.ViewModel)
	func displayAddedTransaction(_ viewModel: Home.AddTransaction.ViewModel)
	func displayEditedTransaction(_ viewModel: Home.EditTransaction.ViewModel)
	func displayFinancialSummary(_ viewModel: Home.FetchFinancialSummary.ViewModel)
	func displayRemoveTransaction(_ viewModel: Home.RemoveTransaction.ViewModel)
	func displayAlertEditStartingBalance(_ viewModel: Home.AlertEditStartingBalance.ViewModel)
	func displayAlertDatePicker(_ viewModel: Home.AlertDatePicker.ViewModel)
	func displayDatePickerButton(_ viewModel: Home.DatePickerButton.ViewModel)
	func displayStartingBalance(_ viewModel: Home.EditStartingBalance.ViewModel)
}

class HomeViewController: UIViewController {

	@IBOutlet weak var financialSummaryCollectionView: UICollectionView!
	
	@IBOutlet weak var balanceAmountLabel: UILabel!

	@IBOutlet weak var expenseAmountLabel: UILabel!

	@IBOutlet weak var incomeAmountLabel: UILabel!

	@IBOutlet weak var transactionsTableView: UITableView!

	@IBOutlet weak var addTransactionButton: UIButton!

	@IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!

	@IBOutlet weak var datePickerButton: UIButton!
	
	@IBOutlet weak var menuButton: UIButton!

	public var interactor: HomeBusinessLogic?

	public var router: HomeRoutingLogic?

	private(set) var transactionsArray: [TransactionTableViewCellModel] = []
	
	private(set) var financialSummaryData: [FinancialSummaryCellModel] = []
	
	let financialSummaryCellSpacing: CGFloat = 16

	private var (month, year): (Int, Int) = (0, 0)

    override func viewDidLoad() {
        super.viewDidLoad()

		setup()
		configurations()

    }

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		updateFinancialSummaryCellSize()
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
		configureFinancialSummaryCollectionView()
		configureTransactionsTableView()
		configureMenuButton()

		month = currentDate().month
		year = currentDate().year
		interactor?.fetchTransactions(Home.FetchTransactions.Request(month: month, year: year))
		interactor?.fetchFinancialSummary(Home.FetchFinancialSummary.Request())

		addNotificationObservers()

		interactor?.updateDatePickerButton(Home.DatePickerButton.Request())
		
	}
	
	private func configureFinancialSummaryCollectionView() {
		financialSummaryCollectionView.delegate = self
		financialSummaryCollectionView.dataSource = self
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
											   name: NotificationNames.Currency, object: nil)
	}

	private func currentDate() -> (month: Int, year: Int) {
		let date = Date.now
		let dateComponents = Calendar.current.dateComponents([.month, .year], from: date)
		return (dateComponents.month!, dateComponents.year!)
	}
	
	private func configureMenuButton() {
		let actions: [UIAction] = [
			UIAction(title: NSLocalizedString("settings.title", comment: ""),
					 image: UIImage(systemName: "gearshape"),
					 handler: { _ in
				self.router?.routeToSettings()
			})
		]
		
		menuButton.menu = UIMenu(title: "", children: actions)
		menuButton.showsMenuAsPrimaryAction = true
	}
	
	private func updateFinancialSummaryCellSize() {
		if let flowLayout = financialSummaryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			let width = financialSummaryCollectionView.bounds.width / 2 - financialSummaryCellSpacing / 2
			let height = financialSummaryCollectionView.bounds.height / 2 - financialSummaryCellSpacing / 2
			
			flowLayout.itemSize = CGSize(width: width, height: height)
			flowLayout.invalidateLayout()
		}
	}
	
	private func updateTransactionsTableView(_ transactions: [TransactionTableViewCellModel]) {
		transactionsArray = transactions
		DispatchQueue.main.async {
			self.transactionsTableView.reloadData()
		}
	}

	@objc
	private func changeCurrency() {
		
		interactor?.fetchTransactions(Home.FetchTransactions.Request(month: month, year: year))
		interactor?.fetchFinancialSummary(Home.FetchFinancialSummary.Request())
	}

	// MARK: Actions
	@IBAction func addTransactionButtonClicked(_ sender: Any) {
		router?.routeToAddNewTransaction()
	}

	@IBAction func selectDateButtonClicked(_ sender: Any) {

		let selectedMonthYearAction = { (month: Int, year: Int) in
			self.month = month
			self.year = year
			
			let request = Home.FetchTransactions.Request(month: month, year: year)
			self.interactor?.fetchTransactions(request)

			self.interactor?.fetchFinancialSummary(Home.FetchFinancialSummary.Request())
			self.interactor?.updateDatePickerButton(Home.DatePickerButton.Request())
		}

		let request = Home.AlertDatePicker.Request(action: selectedMonthYearAction)
		interactor?.showAlertDatePicker(request)
	}

}

// MARK: - Display logic
extension HomeViewController: HomeDisplayLogic {

	func displayTransactions(_ viewModel: Home.FetchTransactions.ViewModel) {
		updateTransactionsTableView(viewModel.data)
	}
	
	func displayAddedTransaction(_ viewModel: Home.AddTransaction.ViewModel) {
		updateTransactionsTableView(viewModel.data)
	}
	
	func displayEditedTransaction(_ viewModel: Home.EditTransaction.ViewModel) {
		updateTransactionsTableView(viewModel.data)
	}

	func displayFinancialSummary(_ viewModel: Home.FetchFinancialSummary.ViewModel) {
		
		financialSummaryData.removeAll()
		
		financialSummaryData.append(viewModel.startingBalance)
		financialSummaryData.append(viewModel.balance)
		financialSummaryData.append(viewModel.expense)
		financialSummaryData.append(viewModel.income)
		
		DispatchQueue.main.async {
			self.financialSummaryCollectionView.reloadData()
		}
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
	
	func displayStartingBalance(_ viewModel: Home.EditStartingBalance.ViewModel) {
		financialSummaryData.removeAll()
		
		financialSummaryData.append(viewModel.startingBalance)
		financialSummaryData.append(viewModel.balance)
		financialSummaryData.append(viewModel.expense)
		financialSummaryData.append(viewModel.income)
		
		DispatchQueue.main.async {
			self.financialSummaryCollectionView.reloadData()
		}
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
