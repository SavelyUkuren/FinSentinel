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
	func displayPeriodButtonTitle(_ viewModel: AnalyticsModels.UpdatePeriodButtonTitle.ViewModel)
}

class AnalyticsViewController: UIViewController {
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	@IBOutlet weak var transactionTypeSegmentControl: UISegmentedControl!
	
	@IBOutlet weak var periodSegmentControl: UISegmentedControl!
	
	@IBOutlet weak var periodSelectButton: UIButton!
	
	@IBOutlet weak var chartView: BarChartView!
	
	@IBOutlet weak var chartViewHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var summaryCollectionView: UICollectionView!
	
	@IBOutlet weak var summaryCollectionViewHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var amountsByCategoriesTableView: UITableView!
	
	@IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
	
	public var interactor: AnalyticsBusinessLogic?
	
	private var transactionType: TransactionType = .expense
	
	private var period: AnalyticsModels.Period = .month
	
	private var (month, year) = (0, 0)
	
	private var categories: [AnalyticsModels.CategorySummaryModel] = []
	
	private var summary: [FinancialSummaryCellModel] = []
	
	private let chartViewDefaultHeight: CGFloat = 200
	
	let financialSummaryCellSpacing: CGFloat = 16
	
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
																transactionType: transactionType)
		interactor?.fetchTransactions(request)
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		updateFinancialSummaryCellSize()
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
		
		configureChartView()
		configureTransactionTypeSegmentControl()
		configurePeriodSegmentControl()
		
		updatePeriodButtonTitle()
		
		amountsByCategoriesTableView.delegate = self
		amountsByCategoriesTableView.dataSource = self
		
		summaryCollectionView.delegate = self
		summaryCollectionView.dataSource = self
		
		fetchTransactions()
	}
	
	private func configureChartView() {
		chartView.legend.enabled = false
		chartView.xAxis.labelPosition = .bottom
		chartView.xAxis.gridLineDashLengths = [2]
		chartView.xAxis.axisLineWidth = 0
		chartView.xAxis.setLabelCount(10, force: false)
		chartView.dragEnabled = false
		
		chartView.leftAxis.drawLabelsEnabled = false
	}
	
	private func configureTransactionTypeSegmentControl() {
		transactionTypeSegmentControl.setTitle(NSLocalizedString("expense.title", comment: ""),
											   forSegmentAt: 0)
		transactionTypeSegmentControl.setTitle(NSLocalizedString("income.title", comment: ""),
											   forSegmentAt: 1)
	}
	
	private func configurePeriodSegmentControl() {
		periodSegmentControl.setTitle(NSLocalizedString("month.title", comment: ""),
									  forSegmentAt: 0)
		periodSegmentControl.setTitle(NSLocalizedString("year.title", comment: ""),
									  forSegmentAt: 1)
		periodSegmentControl.setTitle(NSLocalizedString("all.title", comment: ""),
									  forSegmentAt: 2)
	}
	
	private func fetchTransactions() {
		let request = AnalyticsModels.FetchTransactions.Request(month: month,
																year: year,
																period: period,
																transactionType: transactionType)
		interactor?.fetchTransactions(request)
	}
	
	private func updateFinancialSummaryCellSize() {
		if let flowLayout = summaryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			let width = summaryCollectionView.bounds.width / 2 - financialSummaryCellSpacing / 2
			
			flowLayout.itemSize = CGSize(width: width, height: summaryCollectionViewHeightConstraint.constant)
			flowLayout.invalidateLayout()
		}
	}
	
	private func updatePeriodButtonTitle() {
		let request = AnalyticsModels.UpdatePeriodButtonTitle.Request(month: month, year: year)
		interactor?.updatePeriodButtonTitle(request)
	}

	// MARK: - Actions
	@IBAction func didModeSegmentValueChanged(_ sender: Any) {
		switch transactionTypeSegmentControl.selectedSegmentIndex {
			case 0:
				transactionType = .expense
			case 1:
				transactionType = .income
			default:
				transactionType = .expense
		}
		fetchTransactions()
	}
	
	@IBAction func didPeriodSegmentValueChanged(_ sender: Any) {
		switch periodSegmentControl.selectedSegmentIndex {
			case 0:
				period = .month
				periodSelectButton.setTitle("\(month) \(year)", for: .normal)
				periodSelectButton.isEnabled = true
				chartViewHeightConstraint.constant = chartViewDefaultHeight
				chartView.layoutIfNeeded()
				updatePeriodButtonTitle()
			case 1:
				period = .year
				periodSelectButton.setTitle("\(year)", for: .normal)
				periodSelectButton.isEnabled = true
				chartViewHeightConstraint.constant = chartViewDefaultHeight
				chartView.layoutIfNeeded()
			case 2:
				period = .all
				periodSelectButton.isEnabled = false
				chartViewHeightConstraint.constant = 0
				chartView.layoutIfNeeded()
			default:
				period = .month
		}
		fetchTransactions()
	}
	
	@IBAction func didPeriodButtonClicked(_ sender: Any) {
		
		if period == .month {
			
			let action: (Int, Int) -> () = { month, year in
				self.year = year
				self.month = month
				self.periodSelectButton.setTitle("\(month) \(year)", for: .normal)
				self.fetchTransactions()
				self.updatePeriodButtonTitle()
			}
			
			let request = AnalyticsModels.ShowMonthYearWheel.Request(action: action)
			interactor?.showMonthAndYearWheelAlert(request)
			
		} else if period == .year {
			
			let action: (Int) -> () = { year in
				self.year = year
				self.periodSelectButton.setTitle("\(year)", for: .normal)
				self.fetchTransactions()
			}
			
			let request = AnalyticsModels.ShowYearsWheel.Request(action: action)
			interactor?.showYearsWheelAlert(request)
			
		} else if period == .all {
			
			self.fetchTransactions()
		}

	}
	
}

// MARK: - TableView delegate
extension AnalyticsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		categories.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TotalCategoryAmountTableViewCell
		
		let index = indexPath.row
		
		cell.categoryTitleLabel.text = categories[index].title
		cell.categoryImageView.image = categories[index].icon
		cell.amountLabel.text = categories[index].amount
		cell.amountLabel.textColor = categories[index].amountColor
		
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
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (collectionView.bounds.width / 2) - (financialSummaryCellSpacing / 2)

		return CGSize(width: width, height: summaryCollectionViewHeightConstraint.constant)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		financialSummaryCellSpacing
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
		chartView.data?.setDrawValues(false)
	}
	
	func displayMonthYearWheelAlert(_ viewModel: AnalyticsModels.ShowMonthYearWheel.ViewModel) {
		present(viewModel.alert, animated: true)
	}
	
	func displayYearsWheelAlert(_ viewModel: AnalyticsModels.ShowYearsWheel.ViewModel) {
		present(viewModel.alert, animated: true)
	}
	
	func displayPeriodButtonTitle(_ viewModel: AnalyticsModels.UpdatePeriodButtonTitle.ViewModel) {
		periodSelectButton.setTitle(viewModel.title, for: .normal)
	}
	
}
