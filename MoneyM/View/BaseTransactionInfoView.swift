//
//  BaseTransactionInfoView.swift
//  MoneyM
//
//  Created by Air on 16.09.2023.
//

import UIKit

protocol BaseTransactionInfoViewDelegate {
    func confirmButtonClicked(transaction: TransactionModel)
    func selectCategoryButtonClicked()
}

class BaseTransactionInfoView: UIView {
    
    public var selectedMode: TransactionModel.Mode = .Expense
    public var selectedCategory: CategoryModel = Categories.defaultCategory
    
    public var categories: Categories!
    
    public let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "The amount"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let amountTextField: UITextField = {
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

    public let confirmButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Confirm", for: .normal)
        return button
    }()
    
    public let selectModeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    public let expenseButton: UIButton = {
        let button = UIButton(configuration: .bordered())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Expense", for: .normal)
        return button
    }()
    
    public let incomeButton: UIButton = {
        let button = UIButton(configuration: .bordered())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Income", for: .normal)
        return button
    }()
    
    public let selectCategoryButton: UIButton = {
        let button = UIButton(configuration: .gray())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select category", for: .normal)
        return button
    }()
    
    public let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        categories = Categories()
        
        configureAmountLabel()
        configureAmountTextField()
        configureAddTransactionButton()
        configureSelectModeStackView()
        configureSelectCategoryButton()
        configureDatePicker()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc
    public func configrmButtonClicked() {
        
    }
    
    @objc
    public func incomeButtonClicked() {
        incomeButton.backgroundColor = .systemBlue
        incomeButton.setTitleColor(.white, for: .normal)
        
        expenseButton.backgroundColor = .systemGray6
        expenseButton.setTitleColor(.systemBlue, for: .selected)
        
        selectedMode = .Income
    }
    
    @objc
    public func expenseButtonClicked() {
        expenseButton.backgroundColor = .systemBlue
        expenseButton.setTitleColor(.white, for: .normal)
        
        incomeButton.backgroundColor = .systemGray6
        incomeButton.setTitleColor(.systemBlue, for: .normal)
        
        selectedMode = .Expense
    }
    
    @objc
    public func selectCategoryButtonClicked() {
        
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
        addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: UIStyle.ButtonHeight)
        ])
        
        confirmButton.addTarget(self, action: #selector(configrmButtonClicked), for: .touchUpInside)
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
            selectModeStackView.heightAnchor.constraint(equalToConstant: UIStyle.ButtonHeight)
        ])
    }
    
    private func configureSelectCategoryButton() {
        addSubview(selectCategoryButton)
        
        NSLayoutConstraint.activate([
            selectCategoryButton.topAnchor.constraint(equalTo: selectModeStackView.bottomAnchor, constant: 32),
            selectCategoryButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            selectCategoryButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            selectCategoryButton.heightAnchor.constraint(equalToConstant: UIStyle.ButtonHeight)
        ])
        
        selectCategoryButton.addTarget(self, action: #selector(selectCategoryButtonClicked), for: .touchUpInside)
    }

    private func configureDatePicker() {
        addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: selectCategoryButton.bottomAnchor, constant: 32),
            amountTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            amountTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.subviews.first!.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
}

extension BaseTransactionInfoView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextField.resignFirstResponder()
        return true
    }
}
