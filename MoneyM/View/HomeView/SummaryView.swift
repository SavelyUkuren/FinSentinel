//
//  SummaryView.swift
//  MoneyM
//
//  Created by Air on 07.11.2023.
//

import Foundation
import UIKit

class SummaryView: UIView {
    
    private let balanceView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = UIStyle.CornerRadius
        view.backgroundColor = UIStyle.UIViewBackgroundColor
        return view
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Balance"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let balanceAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    private let editBalanceButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setTitle("Edit", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIStyle.AccentColor, for: .normal)
        return button
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
        view.layer.cornerRadius = UIStyle.CornerRadius
        view.backgroundColor = UIStyle.UIViewBackgroundColor
        return view
    }()
    
    private let expenseLabel: UILabel = {
        let label = UILabel()
        label.text = "Expenses"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let expenseAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26)
        label.textColor = UIStyle.ExpenseColor
        return label
    }()
    
    private let incomesView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = UIStyle.CornerRadius
        view.backgroundColor = UIStyle.UIViewBackgroundColor
        return view
    }()
    
    private let incomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Incomes"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let incomeAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26)
        label.textColor = UIStyle.IncomeColor
        return label
    }()
    
    private var editButtonAction: () -> () = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureBalanceView()
        configureExpensesView()
        configureIncomesView()
        configureIncomeExpenseStackView()
        configureExpenseLabel()
        configureIncomeLabel()
        configureBalanceLabel()
        configureEditBalanceButton()
        configureBalanceAmountLabel()
        configureExpenseAmountLabel()
        configureIncomeAmountLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func addActionForEditBalanceButton(_ action: @escaping () -> ()) {
        editButtonAction = action
    }
    
    public func setBalance(amount: Int, currency: CurrencyModel) {
        balanceAmountLabel.text = "\(amount) \(currency.symbol)"
        balanceAmountLabel.textColor = amount < 0 ? UIStyle.ExpenseColor : UIStyle.IncomeColor
    }
    
    public func setExpense(amount: Int, currency: CurrencyModel) {
        expenseAmountLabel.text = "\(amount) \(currency.symbol)"
    }
    
    public func setIncome(amount: Int, currency: CurrencyModel) {
        incomeAmountLabel.text = "\(amount) \(currency.symbol)"
    }
    
    private func configureBalanceView() {
        addSubview(balanceView)
        
        NSLayoutConstraint.activate([
            balanceView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            balanceView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            balanceView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            balanceView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
        
    }
    
    private func configureIncomeExpenseStackView() {
        addSubview(expenseIncomeStackView)
        
        expenseIncomeStackView.addArrangedSubview(expensesView)
        expenseIncomeStackView.addArrangedSubview(incomesView)
        
        NSLayoutConstraint.activate([
            expenseIncomeStackView.topAnchor.constraint(equalTo: balanceView.bottomAnchor, constant: 16),
            expenseIncomeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            expenseIncomeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            expenseIncomeStackView.heightAnchor.constraint(equalToConstant: 120)
            
        ])
        
    }
    
    private func configureExpensesView() {
        addSubview(expensesView)
        expensesView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    private func configureIncomesView() {
        addSubview(incomesView)
        incomesView.heightAnchor.constraint(equalToConstant: 120).isActive = true
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
    
    private func configureEditBalanceButton() {
        balanceView.addSubview(editBalanceButton)
        
        NSLayoutConstraint.activate([
            editBalanceButton.topAnchor.constraint(equalTo: balanceView.topAnchor, constant: 16),
            editBalanceButton.trailingAnchor.constraint(equalTo: balanceView.trailingAnchor, constant: -16),
        ])
        
        editBalanceButton.addTarget(self, action: #selector(editBalanceButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func editBalanceButtonClicked() {
        editButtonAction()
    }
    
}
