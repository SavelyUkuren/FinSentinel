//
//  AnalyticsViewController.swift
//  MoneyM
//
//  Created by savik on 05.01.2024.
//

import UIKit
import DGCharts

protocol AnalyticsDisplayLogic {
	func displayAnalyticsData(_ viewModel: AnalyticsModels.FetchTransactions.ViewModel)
	func displayMonthYearWheelAlert(_ viewModel: AnalyticsModels.ShowMonthYearWheel.ViewModel)
	func displayYearsWheelAlert(_ viewModel: AnalyticsModels.ShowYearsWheel.ViewModel)
}

class AnalyticsViewController: UIViewController {

	@IBOutlet weak var modeSegmentControl: UISegmentedControl!
	
	@IBOutlet weak var periodSegmentControl: UISegmentedControl!
	
	@IBOutlet weak var periodSelectButton: UIButton!
	
	@IBOutlet weak var chartView: BarChartView!
	
	@IBOutlet weak var summaryCollectionView: UICollectionView!
	
	@IBOutlet weak var amountsByCategoriesTableView: UITableView!
	
	public var interactor: AnalyticsBusinessLogic?
	
	private var mode: AnalyticsModels.TransactionType = .expense
	
	private var period: AnalyticsModels.Period = .month
	
	private var (month, year) = (0, 0)
	
	private var categories: [AnalyticsModels.CategorySummaryModel] = []
	
	private var summary: [FinancialSummaryCellModel] = []
	
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
																transactionType: mode)
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
		
		periodSelectButton.setTitle("\(month) \(year)", for: .normal)
		
		amountsByCategoriesTableView.delegate = self
		amountsByCategoriesTableView.dataSource = self
		
		summaryCollectionView.delegate = self
		summaryCollectionView.dataSource = self
		
		let request = AnalyticsModels.FetchTransactions.Request(month: month,
																year: year,
																period: period,
																transactionType: mode)
		interactor?.fetchTransactions(request)
	}
	
	private func updateData() {
		let request = AnalyticsModels.FetchTransactions.Request(month: month,
																year: year,
																period: period,
																transactionType: mode)
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
																transactionType: mode)
		self.interactor?.fetchTransactions(request)
	}
	
	@IBAction func didPeriodSegmentValueChanged(_ sender: Any) {
		switch periodSegmentControl.selectedSegmentIndex {
			case 0:
				period = .month
				periodSelectButton.setTitle("\(month) \(year)", for: .normal)
				periodSelectButton.isEnabled = true
			case 1:
				period = .year
				periodSelectButton.setTitle("\(year)", for: .normal)
				periodSelectButton.isEnabled = true
			case 2:
				period = .all
				periodSelectButton.isEnabled = false
			default:
				period = .month
		}
		let request = AnalyticsModels.FetchTransactions.Request(month: month,
																year: year,
																period: period,
																transactionType: mode)
		self.interactor?.fetchTransactions(request)
	}
	
	@IBAction func didPeriodButtonClicked(_ sender: Any) {
		
		if period == .month {
			
			let action: (Int, Int) -> () = { month, year in
				self.year = year
				self.month = month
				self.periodSelectButton.setTitle("\(month) \(year)", for: .normal)
				self.updateData()
			}
			
			let request = AnalyticsModels.ShowMonthYearWheel.Request(action: action)
			interactor?.showMonthAndYearWheelAlert(request)
			
		} else if period == .year {
			
			let action: (Int) -> () = { year in
				self.year = year
				self.periodSelectButton.setTitle("\(year)", for: .normal)
				self.updateData()
			}
			
			let request = AnalyticsModels.ShowYearsWheel.Request(action: action)
			interactor?.showYearsWheelAlert(request)
			
		} else if period == .all {
			
			self.updateData()
		}

	}
	
}

// MARK: - TableView delegate
extension AnalyticsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		categories.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TotalCategoryAmountTableViewCell
		
		let index = indexPath.row
		
		cell.categoryTitleLabel.text = categories[index].title
		cell.categoryImageView.image = categories[index].icon
		cell.amountLabel.text = categories[index].amount
		
		return cell
	}
	
}

// MARK: - CollectionView delegate
extension AnalyticsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		summary.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FinancialSummaryCollectionViewCell
		
		let index = indexPath.row
		
		cell.amountLabel.text = summary[index].amount
		cell.amountLabel.textColor = summary[index].amountColor
		cell.titleLabel.text = summary[index].title
		
		return cell
	}
}

// MARK: - Analytics display logic
extension AnalyticsViewController: AnalyticsDisplayLogic {
	func displayAnalyticsData(_ viewModel: AnalyticsModels.FetchTransactions.ViewModel) {
		categories = viewModel.categories
		summary = viewModel.summary
		
		DispatchQueue.main.async {
			self.amountsByCategoriesTableView.reloadData()
			self.summaryCollectionView.reloadData()
		}
		
		chartView.data = viewModel.chartData
		
	}
	
	func displayMonthYearWheelAlert(_ viewModel: AnalyticsModels.ShowMonthYearWheel.ViewModel) {
		present(viewModel.alert, animated: true)
	}
	
	func displayYearsWheelAlert(_ viewModel: AnalyticsModels.ShowYearsWheel.ViewModel) {
		present(viewModel.alert, animated: true)
	}
	
}
