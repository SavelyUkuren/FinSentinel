//
//  AddNewTransactionView.swift
//  MoneyM
//
//  Created by Air on 03.09.2023.
//

import UIKit

protocol AddTransactionViewDelegate {
    func addTransactionButtonClicked(transaction: TransactionModel)
}

class AddTransactionView: UIView {
    
    public var delegate: AddTransactionViewDelegate?
    
    private var selectedMode: TransactionModel.Mode = .Expense
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "The amount"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 16
        textField.layer.borderColor = UIColor.systemGray6.cgColor
        textField.backgroundColor = .systemGray6
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        return textField
    }()

    private let addTransactionButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add", for: .normal)
        return button
    }()
    
    private let selectModeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let expenseButton: UIButton = {
        let button = UIButton(configuration: .bordered())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Expense", for: .normal)
        return button
    }()
    
    private let incomeButton: UIButton = {
        let button = UIButton(configuration: .bordered())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Income", for: .normal)
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        configureAmountLabel()
        configureAmountTextField()
        configureAddTransactionButton()
        configureSelectModeStackView()
        configureDatePicker()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc
    public func addTransactionButtonClicked() {
        let transaction = TransactionModel()
        
        transaction.mode = selectedMode
        transaction.date = datePicker.date
        transaction.category = "Test"
        transaction.amount = amountTextField.text
        
        delegate?.addTransactionButtonClicked(transaction: transaction)
    }
    
    @objc
    private func incomeButtonClicked() {
        incomeButton.backgroundColor = .systemBlue
        incomeButton.setTitleColor(.white, for: .normal)
        
        expenseButton.backgroundColor = .systemGray6
        expenseButton.setTitleColor(.systemBlue, for: .selected)
        
        selectedMode = .Income
    }
    
    @objc
    private func expenseButtonClicked() {
        expenseButton.backgroundColor = .systemBlue
        expenseButton.setTitleColor(.white, for: .normal)
        
        incomeButton.backgroundColor = .systemGray6
        incomeButton.setTitleColor(.systemBlue, for: .normal)
        
        selectedMode = .Expense
    }
    
    private func configureAmountLabel() {
        addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 48),
            amountLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        //amountTextField.addTarget(self, action: #selector(amountTextFieldTextChanged), for: .editingChanged)
    }
    
    private func configureAmountTextField() {
        addSubview(amountTextField)
        
        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 16),
            amountTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            amountTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            amountTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        amountTextField.returnKeyType = .done
        amountTextField.delegate = self
    }
    
    private func configureAddTransactionButton() {
        addSubview(addTransactionButton)
        
        NSLayoutConstraint.activate([
            addTransactionButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addTransactionButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addTransactionButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addTransactionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        addTransactionButton.addTarget(self, action: #selector(addTransactionButtonClicked), for: .touchUpInside)
    }
    
    private func configureSelectModeStackView() {
        addSubview(selectModeStackView)
        
        expenseButton.addTarget(self, action: #selector(expenseButtonClicked), for: .touchUpInside)
        incomeButton.addTarget(self, action: #selector(incomeButtonClicked), for: .touchUpInside)
        
        selectModeStackView.addArrangedSubview(expenseButton)
        selectModeStackView.addArrangedSubview(incomeButton)
        
        NSLayoutConstraint.activate([
            selectModeStackView.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 50),
            selectModeStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            selectModeStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            selectModeStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func configureDatePicker() {
        addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: selectModeStackView.bottomAnchor, constant: 32),
            amountTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            amountTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.subviews.first!.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
}

extension AddTransactionView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextField.resignFirstResponder()
        return true
    }
}
