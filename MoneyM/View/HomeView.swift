//
//  HomeView.swift
//  MoneyM
//
//  Created by Air on 30.08.2023.
//

import UIKit

protocol HomeViewDelegate {
    func addNewTransactionButtonClicked()
}

class HomeView: UIView {
    
    public var delegate: HomeViewDelegate?

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
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isScrollEnabled = false
        return tableView
    }()
    private var transactionsTableViewHeight: NSLayoutConstraint!
    
    private let balanceView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Balance"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let balanceAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expenseIncomeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let expensesView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let expenseLabel: UILabel = {
        let label = UILabel()
        label.text = "Expenses"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expenseAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let incomesView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let incomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Incomes"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let incomeAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let datePickerButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Date", for: .normal)
        return button
    }()
    
    private let addTransactionButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
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
        transactionsTableViewHeight.constant = transactionsTableView.contentSize.height + 50
    }
    
    public func reloadTransactionsTableView() {
        transactionsTableView.reloadData()
    }
    
    public func reloadStats(transactions: [TransactionModel]) {
        var balance = 0
        var expense = 0
        var income = 0
        
        for transaction in transactions {
            if transaction.mode == .Expense {
                expense += Int(transaction.amount ?? "0") ?? 0
            } else {
                income += Int(transaction.amount ?? "0") ?? 0
            }
        }
        
        balance += income - expense
        
        balanceAmountLabel.text = "\(balance)"
        expenseAmountLabel.text = "\(expense)"
        incomeAmountLabel.text = "\(income)"
    }
    
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
        configureBalanceView()
        configureExpensesView()
        configureIncomesView()
        configureIncomeExpenseStackView()
        configureDatePickerButton()
        configureTransactionsTableView()
        configureExpenseLabel()
        configureIncomeLabel()
        configureBalanceLabel()
        configureBalanceAmountLabel()
        configureExpenseAmountLabel()
        configureIncomeAmountLabel()
    }
    
    private func configureBalanceView() {
        contentView.addSubview(balanceView)
        
        NSLayoutConstraint.activate([
            balanceView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            balanceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            balanceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            balanceView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
        
    }
    
    private func configureIncomeExpenseStackView() {
        contentView.addSubview(expenseIncomeStackView)
        
        expenseIncomeStackView.addArrangedSubview(expensesView)
        expenseIncomeStackView.addArrangedSubview(incomesView)
        
        NSLayoutConstraint.activate([
            expenseIncomeStackView.topAnchor.constraint(equalTo: balanceView.bottomAnchor, constant: 16),
            expenseIncomeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            expenseIncomeStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            expenseIncomeStackView.heightAnchor.constraint(equalToConstant: 120)
            
        ])
        
    }
    
    private func configureExpensesView() {
        contentView.addSubview(expensesView)
        expensesView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    private func configureIncomesView() {
        contentView.addSubview(incomesView)
        incomesView.heightAnchor.constraint(equalToConstant: 120).isActive = true
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
    
    private func configureDatePickerButton() {
        contentView.addSubview(datePickerButton)
        
        NSLayoutConstraint.activate([
            datePickerButton.topAnchor.constraint(equalTo: expenseIncomeStackView.bottomAnchor, constant: 16),
            datePickerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            datePickerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            datePickerButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configurateAddTransactionButton() {
        addSubview(addTransactionButton)
        
        NSLayoutConstraint.activate([
            addTransactionButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addTransactionButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addTransactionButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addTransactionButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        addTransactionButton.addTarget(self, action: #selector(addTransactionButtonClicked), for: .touchUpInside)
    }
    
    private func configureExpenseLabel() {
        expensesView.addSubview(expenseLabel)
        
        NSLayoutConstraint.activate([
            expenseLabel.topAnchor.constraint(equalTo: expensesView.topAnchor, constant: 16),
            expenseLabel.centerXAnchor.constraint(equalTo: expensesView.centerXAnchor)
        ])
    }
    
    private func configureIncomeLabel() {
        incomesView.addSubview(incomeLabel)
        
        NSLayoutConstraint.activate([
            incomeLabel.topAnchor.constraint(equalTo: incomesView.topAnchor, constant: 16),
            incomeLabel.centerXAnchor.constraint(equalTo: incomesView.centerXAnchor)
        ])
    }
    
    private func configureBalanceLabel() {
        balanceView.addSubview(balanceLabel)
        
        NSLayoutConstraint.activate([
            balanceLabel.topAnchor.constraint(equalTo: balanceView.topAnchor, constant: 16),
            balanceLabel.centerXAnchor.constraint(equalTo: balanceView.centerXAnchor)
        ])
    }
    
    private func configureBalanceAmountLabel() {
        balanceView.addSubview(balanceAmountLabel)
        
        NSLayoutConstraint.activate([
            balanceAmountLabel.centerXAnchor.constraint(equalTo: balanceView.centerXAnchor),
            balanceAmountLabel.centerYAnchor.constraint(equalTo: balanceView.centerYAnchor)
        ])
    }
    
    private func configureExpenseAmountLabel() {
        expensesView.addSubview(expenseAmountLabel)
        
        NSLayoutConstraint.activate([
            expenseAmountLabel.centerXAnchor.constraint(equalTo: expensesView.centerXAnchor),
            expenseAmountLabel.centerYAnchor.constraint(equalTo: expensesView.centerYAnchor)
        ])
    }
    
    private func configureIncomeAmountLabel() {
        incomesView.addSubview(incomeAmountLabel)
        
        NSLayoutConstraint.activate([
            incomeAmountLabel.centerXAnchor.constraint(equalTo: incomesView.centerXAnchor),
            incomeAmountLabel.centerYAnchor.constraint(equalTo: incomesView.centerYAnchor)
        ])
    }
    
    @objc
    private func addTransactionButtonClicked() {
        delegate?.addNewTransactionButtonClicked()
    }
    
}
