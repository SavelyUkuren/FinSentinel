//
//  AddTransactionViewController.swift
//  MoneyM
//
//  Created by Air on 03.09.2023.
//

import UIKit

protocol AddTransactionViewControllerDelegate {
    func transactionCreated(transaction: TransactionModel)
}

class AddTransactionViewControllerDeprecate: UIViewController {
    
    public var delegate: AddTransactionViewControllerDelegate?
    
    private var addTransactionView: AddTransactionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureAddTransactionView()
    }

    private func configureAddTransactionView() {
        addTransactionView = AddTransactionView(frame: view.frame)
        addTransactionView.translatesAutoresizingMaskIntoConstraints = false
        addTransactionView.delegate = self
		addTransactionView.accentColor = Settings.shared.model.accentColor
        self.view = addTransactionView
    }
    
    private func showErrorAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
}

// MARK: Base transaction info delegate
extension AddTransactionViewControllerDeprecate: TransactionEditorViewDelegate {
    
    func selectCategoryButtonClicked() {
        let selectCategoryVC = CategoriesViewController()
        selectCategoryVC.delegate = self
        selectCategoryVC.categoryType = addTransactionView.selectedMode
        
        present(selectCategoryVC, animated: true)
    }
    
    func confirmButtonClicked(transaction: TransactionModel) {
        let amountText = addTransactionView.amountTextField.text!
        
        guard !amountText.isEmpty else {
            showErrorAlert("Error!", "Amount is empty!")
            return
        }
        
        guard amountText.isNumber else {
            showErrorAlert("Error!", "The amount must contain only numbers!")
            return
        }
        
        delegate?.transactionCreated(transaction: transaction)
        
        dismiss(animated: true)
    }
    
}

// MARK: Select category delegate
extension AddTransactionViewControllerDeprecate: SelectCategoryViewControllerDelegate {
    func selectButtonClicked(category: CategoryModel?) {
        guard category != nil else { return }
        addTransactionView.selectedCategory = category ?? CategoriesManager.defaultCategory
        addTransactionView.selectCategoryButton.setTitle(category?.title, for: .normal)
    }
}
