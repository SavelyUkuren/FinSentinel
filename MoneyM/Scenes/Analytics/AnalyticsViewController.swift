//
//  AnalyticsViewController.swift
//  MoneyM
//
//  Created by savik on 05.01.2024.
//

import UIKit

protocol AnalyticsDisplayLogic {
	func displayAnalyticsData(_ viewModel: AnalyticsModels.FetchTransactionsByMonth.ViewModel)
}

class AnalyticsViewController: UIViewController {
	
	enum Mode {
		case expense, income
	}
	
	enum Period {
		case month, year, all
	}

	@IBOutlet weak var modeSegmentControl: UISegmentedControl!
	
	@IBOutlet weak var periodSegmentControl: UISegmentedControl!
	
	@IBOutlet weak var periodSelectButton: UIButton!
	
	@IBOutlet weak var chartView: UIView!
	
	@IBOutlet weak var summaryCollectionView: UICollectionView!
	
	@IBOutlet weak var amountsByCategoriesTableView: UITableView!
	
	public var interactor: AnalyticsBusinessLogic?
	
	private var mode: Mode = .expense
	
	private var period: Period = .month
	
	private var (month, year) = (0, 0)
	
	private var categories: [AnalyticsModels.CategorySummaryModel] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        setup()
		configure()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		let request = AnalyticsModels.FetchTransactionsByMonth.Request(month: month, year: year)
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
		
		let request = AnalyticsModels.FetchTransactionsByMonth.Request(month: month, year: year)
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
	}
	
	@IBAction func didPeriodButtonClicked(_ sender: Any) {
		
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
	func displayAnalyticsData(_ viewModel: AnalyticsModels.FetchTransactionsByMonth.ViewModel) {
		categories = viewModel.categories
		amountsByCategoriesTableView.reloadData()
	}
}
