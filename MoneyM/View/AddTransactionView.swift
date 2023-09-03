//
//  AddNewTransactionView.swift
//  MoneyM
//
//  Created by Air on 03.09.2023.
//

import UIKit

protocol AddTransactionDelegate {
    func addTransactionButtonClicked()
    func incomeButtonClicked()
    func expenseButtonClicked()
    func amountTextFieldChanged(text: String)
}

class AddTransactionView: UIView {
    
    public var delegate: AddTransactionDelegate?
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        configureAmountLabel()
        configureAmountTextField()
        configureAddTransactionButton()
        configureSelectModeStackView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc
    public func addTransactionButtonClicked() {
        delegate?.addTransactionButtonClicked()
    }
    
    @objc
    public func incomeButtonClicked() {
        incomeButton.backgroundColor = .systemBlue
        incomeButton.setTitleColor(.white, for: .normal)
        
        expenseButton.backgroundColor = .systemGray6
        expenseButton.setTitleColor(.systemBlue, for: .selected)
        
        delegate?.incomeButtonClicked()
    }
    
    @objc
    public func expenseButtonClicked() {
        expenseButton.backgroundColor = .systemBlue
        expenseButton.setTitleColor(.white, for: .normal)
        
        incomeButton.backgroundColor = .systemGray6
        incomeButton.setTitleColor(.systemBlue, for: .normal)
        
        
        delegate?.expenseButtonClicked()
    }
    
    @objc
    public func amountTextFieldTextChanged() {
        delegate?.amountTextFieldChanged(text: amountTextField.text ?? "")
    }
    
    private func configureAmountLabel() {
        addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 48),
            amountLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        amountTextField.addTarget(self, action: #selector(amountTextFieldTextChanged), for: .editingChanged)
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

}

extension AddTransactionView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextField.resignFirstResponder()
        return true
    }
}
