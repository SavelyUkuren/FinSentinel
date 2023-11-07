//
//  HomeView.swift
//  MoneyM
//
//  Created by Air on 30.08.2023.
//

import UIKit

protocol HomeViewDelegate {
    func addNewTransactionButtonClicked()
    func datePickerButtonClicked()
    func editBalanceButtonClicked()
}

class HomeView: UIView {
    
    public var delegate: HomeViewDelegate?

    // MARK: Views
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let transactionsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.layer.cornerRadius = UIStyle.CornerRadius
        tableView.isScrollEnabled = false
        return tableView
    }()
    private var transactionsTableViewHeight: NSLayoutConstraint!
    
    private var summaryView: SummaryView!
    
    private let datePickerButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Date", for: .normal)
        button.setTitleColor(UIStyle.AccentColor, for: .normal)
        return button
    }()
    
    private let addTransactionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIStyle.AccentColor
        button.layer.cornerRadius = UIStyle.CornerRadius
        return button
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIStyle.AppBackgroundColor
        
        configurateAddTransactionButton()
        configureScrollView()
        configureContentView()
        addViewsToContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setTransactionsTableViewDelegate(delegate: UITableViewDelegate) {
        transactionsTableView.delegate = delegate
    }
    
    public func setTransactionsTableViewDataSource(dataSource: UITableViewDataSource) {
        transactionsTableView.dataSource = dataSource
    }
    
    public func updateHeightTransactionTableView() {
        
        var height: CGFloat = 0
        
        // Multiply numbers of section on size section
        height = CGFloat(transactionsTableView.numberOfSections) * UIStyle.TransactionTableViewSectionHeight
        
        // Multiply numbers of rows in section on size row
        for section in 0..<transactionsTableView.numberOfSections {
            let rows = transactionsTableView.numberOfRows(inSection: section)
            height += CGFloat(rows) * UIStyle.TransactionTableViewCellHeight
        }
        
        // Multiply spacing between sections on number of sections
        height += CGFloat(16 * transactionsTableView.numberOfSections)
        
        transactionsTableViewHeight.constant = height
    }
    
    public func reloadTransactionsTableView() {
        transactionsTableView.reloadData()
    }
    
    public func updateExpenseLabel(amount: Int, currency: CurrencyModel) {
        summaryView.setExpense(amount: amount, currency: currency)
    }
    
    public func updateIncomeLabel(amount: Int, currency: CurrencyModel) {
        summaryView.setIncome(amount: amount, currency: currency)
    }
    
    public func updateBalanceLabel(amount: Int, currency: CurrencyModel) {
        summaryView.setBalance(amount: amount, currency: currency)
    }
    
    public func deleteTransaction(indexPath: [IndexPath]) {
        transactionsTableView.deleteRows(at: indexPath, with: .automatic)
    }
    
    public func deleteDateSection(index: Int) {
        transactionsTableView.deleteSections([index], with: .automatic)
    }
    
    public func setDateButtonTitle(dateModel: DateModel) {
        let dateModelManager = DateModelManager()
        
        let month = dateModelManager.months[dateModel.month - 1]
        let year = dateModel.year!
        
        datePickerButton.setTitle("\(month) \(year)", for: .normal)
    }
    
    // MARK: Configurations
    private func configureScrollView() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: addTransactionButton.topAnchor)
        ])
    }
    
    private func configureContentView() {
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func addViewsToContentView() {
        configureSummaryView()
        configureDatePickerButton()
        configureTransactionsTableView()
    }
    
    private func configureSummaryView() {
        summaryView = SummaryView(frame: .zero)
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        summaryView.addActionForEditBalanceButton {
            self.delegate?.editBalanceButtonClicked()
        }
        
        contentView.addSubview(summaryView)
        
        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            summaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            summaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            summaryView.heightAnchor.constraint(equalToConstant: 256)
        ])
    }
    
    private func configureTransactionsTableView() {
        contentView.addSubview(transactionsTableView)
        
        transactionsTableViewHeight = transactionsTableView.heightAnchor.constraint(equalToConstant: 500)
        
        NSLayoutConstraint.activate([
            transactionsTableView.topAnchor.constraint(equalTo: datePickerButton.bottomAnchor, constant: 16),
            transactionsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            transactionsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            transactionsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16),
            transactionsTableViewHeight
        ])
    }
    
    private func configurateAddTransactionButton() {
        addSubview(addTransactionButton)
        
        NSLayoutConstraint.activate([
            addTransactionButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addTransactionButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addTransactionButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addTransactionButton.heightAnchor.constraint(equalToConstant: UIStyle.ButtonHeight)
        ])
        
        addTransactionButton.addTarget(self, action: #selector(addTransactionButtonClicked), for: .touchUpInside)
    }
    
    private func configureDatePickerButton() {
            contentView.addSubview(datePickerButton)
            
            NSLayoutConstraint.activate([
                datePickerButton.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: 16),
                datePickerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                datePickerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                datePickerButton.heightAnchor.constraint(equalToConstant: UIStyle.ButtonHeight)
            ])
            
            datePickerButton.addTarget(self, action: #selector(datePickerButtonClicked), for: .touchUpInside)
        }
    
    // MARK: Actions
    @objc
    private func addTransactionButtonClicked() {
        delegate?.addNewTransactionButtonClicked()
    }
    
    @objc
    private func datePickerButtonClicked() {
        delegate?.datePickerButtonClicked()
    }
    
}
