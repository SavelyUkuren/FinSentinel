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

class TransactionEditorView: UIView, TransactionEditorViewProtocol {
    public var delegate: TransactionEditorViewDelegate?
    
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
    
    public let choiceModeButton: ButtonChoiceView = {
        let view = ButtonChoiceView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        configureChoiceModeButton()
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
    public func selectCategoryButtonClicked() {
        
    }
    
    internal func configureAmountLabel() {
        addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 48),
            amountLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
    }
    
    internal func configureAmountTextField() {
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
    
    internal func configureAddTransactionButton() {
        addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: UIStyle.ButtonHeight)
        ])
        
        confirmButton.addTarget(self, action: #selector(configrmButtonClicked), for: .touchUpInside)
    }
    
    internal func configureChoiceModeButton() {
        addSubview(choiceModeButton)
        
        choiceModeButton.setButtonTitle("Expense", button: .First)
        choiceModeButton.setButtonTitle("Income", button: .Second)
        
        NSLayoutConstraint.activate([
            choiceModeButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 50),
            choiceModeButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            choiceModeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            choiceModeButton.heightAnchor.constraint(equalToConstant: UIStyle.ButtonHeight)
        ])
    }
    
    internal func configureSelectCategoryButton() {
        addSubview(selectCategoryButton)
        
        NSLayoutConstraint.activate([
            selectCategoryButton.topAnchor.constraint(equalTo: choiceModeButton.bottomAnchor, constant: 32),
            selectCategoryButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            selectCategoryButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            selectCategoryButton.heightAnchor.constraint(equalToConstant: UIStyle.ButtonHeight)
        ])
        
        selectCategoryButton.addTarget(self, action: #selector(selectCategoryButtonClicked), for: .touchUpInside)
    }

    internal func configureDatePicker() {
        addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: selectCategoryButton.bottomAnchor, constant: 32),
            amountTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            amountTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.subviews.first!.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
}

extension TransactionEditorView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextField.resignFirstResponder()
        return true
    }
    
}
