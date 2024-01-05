//
//  AnalyticsViewController.swift
//  MoneyM
//
//  Created by savik on 05.01.2024.
//

import UIKit

protocol AnalyticsDisplayLogic {
	func displayAnalyticsData(_ viewModel: AnalyticsModels.FetchTransactions.ViewModel)
}

class AnalyticsViewController: UIViewController {

	@IBOutlet weak var modeSegmentControl: UISegmentedControl!
	
	@IBOutlet weak var periodSegmentControl: UISegmentedControl!
	
	@IBOutlet weak var periodSelectButton: UIButton!
	
	@IBOutlet weak var chartView: UIView!
	
	@IBOutlet weak var summaryCollectionView: UICollectionView!
	
	@IBOutlet weak var amountsByCategoriesTableView: UITableView!
	
	public var interactor: AnalyticsBusinessLogic?
	
	private var mode: AnalyticsModels.Mode = .expense
	
	private var period: AnalyticsModels.Period = .month
	
	private var (month, year) = (0, 0)
	
	private var categories: [AnalyticsModels.CategorySummaryModel] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        setup()
		configure()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		let request = AnalyticsModels.FetchTransactions.Request(month: month,
																year: year,
																period: period,
																mode: mode)
		interactor?.fetchTransactions(request)
	}
	
	private func setup() {
		let viewController = self
		let interactor = AnalyticsInteractor()
		let presenter = AnalyticsPresenter()
		
		viewController.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = viewController
	}
	
	private func configure() {
		month = 1
		year = 2024
		
		amountsByCategoriesTableView.delegate = self
		amountsByCategoriesTableView.dataSource = self
		
		let request = AnalyticsModels.FetchTransactions.Request(month: month,
																year: year,
																period: period,
																mode: mode)
		interactor?.fetchTransactions(request)
	}

	// MARK: - Actions
	@IBAction func didModeSegmentValueChanged(_ sender: Any) {
		switch modeSegmentControl.selectedSegmentIndex {
			case 0:
				mode = .expense
			case 1:
				mode = .income
			default:
				mode = .expense
		}
		let request = AnalyticsModels.FetchTransactions.Request(month: month,
																year: year,
																period: period,
																mode: mode)
		self.interactor?.fetchTransactions(request)
	}
	
	@IBAction func didPeriodSegmentValueChanged(_ sender: Any) {
		switch periodSegmentControl.selectedSegmentIndex {
			case 0:
				period = .month
			case 1:
				period = .year
			case 2:
				period = .all
			default:
				period = .month
		}
		let request = AnalyticsModels.FetchTransactions.Request(month: month,
																year: year,
																period: period,
																mode: mode)
		self.interactor?.fetchTransactions(request)
	}
	
	@IBAction func didPeriodButtonClicked(_ sender: Any) {

		let datePickerVC = UIViewController()
		let pickerView = MonthYearWheelPicker()
		pickerView.minimumDate = Date(timeIntervalSince1970: 0)
		pickerView.maximumDate = .now

		datePickerVC.view = pickerView

		let alert = UIAlertController(title: NSLocalizedString("select_date.title", comment: ""), message: nil, preferredStyle: .actionSheet)
		alert.setValue(datePickerVC, forKey: "contentViewController")

		let selectAction = UIAlertAction(title: NSLocalizedString("select.title", comment: ""), style: .default) { _ in
			self.year = pickerView.year
			self.month = pickerView.month
			
			let request = AnalyticsModels.FetchTransactions.Request(month: self.month,
																	year: self.year,
																	period: self.period,
																	mode: self.mode)
			self.interactor?.fetchTransactions(request)
		}

		let cancelAction = UIAlertAction(title: NSLocalizedString("cancel.title", comment: ""), style: .destructive) {_ in
			alert.dismiss(animated: true)
		}

		alert.addAction(selectAction)
		alert.addAction(cancelAction)
		
		present(alert, animated: true)

	}
	
}

// MARK: - TableView delegate
extension AnalyticsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		categories.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TransactionTableViewCell
		
		let index = indexPath.row
		
		cell.categoryLabel.text = categories[index].title
		cell.categoryImageView.image = categories[index].icon
		cell.amountLabel.text = categories[index].amount
		
		return cell
	}
	
}

// MARK: - Analytics display logic
extension AnalyticsViewController: AnalyticsDisplayLogic {
	func displayAnalyticsData(_ viewModel: AnalyticsModels.FetchTransactions.ViewModel) {
		categories = viewModel.categories
		amountsByCategoriesTableView.reloadData()
	}
}
