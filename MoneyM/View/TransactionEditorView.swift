//
//  BaseTransactionInfoView.swift
//  MoneyM
//
//  Created by Air on 16.09.2023.
//

import UIKit

protocol TransactionEditorViewDelegate {
    func confirmButtonClicked(transaction: TransactionModel)
    func selectCategoryButtonClicked()
}

class TransactionEditorView: UIView {
    
    public var selectedMode: TransactionModel.Mode = .Expense
    public var selectedCategory: CategoryModel = CategoriesManager.defaultCategory
    
    public let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "The amount"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    public let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 0
        textField.layer.cornerRadius = UIStyle.CornerRadius
        textField.layer.borderColor = UIStyle.UIViewBackgroundColor.cgColor
        textField.backgroundColor = UIStyle.UIViewBackgroundColor
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textField.font = .systemFont(ofSize: 22)
        return textField
    }()

    public let confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIStyle.AccentColor
        button.layer.cornerRadius = UIStyle.CornerRadius
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
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Expense", for: .normal)
        button.layer.cornerRadius = UIStyle.CornerRadius
        return button
    }()
    
    public let incomeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Income", for: .normal)
        button.layer.cornerRadius = UIStyle.CornerRadius
        return button
    }()
    
    public let selectCategoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select category", for: .normal)
        button.backgroundColor = UIStyle.UIViewBackgroundColor
        button.setTitleColor(UIStyle.AccentColor, for: .normal)
        button.layer.cornerRadius = UIStyle.CornerRadius
        return button
    }()
    
    public let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.tintColor = UIStyle.AccentColor
        return datePicker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIStyle.AppBackgroundColor
        
        configureAmountLabel()
        configureAmountTextField()
        configureAddTransactionButton()
        configureSelectModeStackView()
        configureSelectCategoryButton()
        configureDatePicker()
        
        expenseButtonClicked()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc
    public func configrmButtonClicked() {
        
    }
    
    @objc
    public func incomeButtonClicked() {
        selectedMode = .Income
        selectIncomeButton()
    }
    
    @objc
    public func expenseButtonClicked() {
        selectedMode = .Expense
        selectExpenseButton()
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
    
    private func selectExpenseButton() {
        incomeButton.backgroundColor = UIStyle.UIViewBackgroundColor
        incomeButton.setTitleColor(UIStyle.AccentColor, for: .normal)
        
        expenseButton.setTitleColor(.white, for: .normal)
        expenseButton.backgroundColor = UIStyle.AccentColor
        
    }
    
    private func selectIncomeButton() {
        expenseButton.backgroundColor = .systemGray5
        expenseButton.setTitleColor(UIStyle.AccentColor, for: .normal)
        
        incomeButton.setTitleColor(.white, for: .normal)
        incomeButton.backgroundColor = UIStyle.AccentColor
        
    }
    
}

extension TransactionEditorView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextField.resignFirstResponder()
        return true
    }
}
