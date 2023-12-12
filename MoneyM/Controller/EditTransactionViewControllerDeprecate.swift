//
//  EditTransactionViewController.swift
//  MoneyM
//
//  Created by Air on 16.09.2023.
//

import UIKit

protocol EditTransactionViewControllerDelegateDeprecated {
    func transactionEdited(transaction: TransactionModel)
}

class EditTransactionViewControllerDeprecate: UIViewController {
    
    public var delegate: EditTransactionViewControllerDelegateDeprecated?

    public var transaction: TransactionModel!
    
    private var editTransactionView: EditTransactionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureEditTransactionView()
        
        editTransactionView.loadTransaction(transaction: transaction)
    }
    
    private func configureEditTransactionView() {
        editTransactionView = EditTransactionView(frame: view.frame)
        editTransactionView.translatesAutoresizingMaskIntoConstraints = false
        editTransactionView.delegate = self
        
        view = editTransactionView
    }
    
    private func showErrorAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }

}

// MARK: Base transaction info delegate
extension EditTransactionViewControllerDeprecate: TransactionEditorViewDelegate {
    
    func selectCategoryButtonClicked() {
        let selectCategoryVC = CategoriesViewController()
        selectCategoryVC.delegate = self
        selectCategoryVC.categoryType = editTransactionView.selectedMode
        
        present(selectCategoryVC, animated: true)
    }
    
    func confirmButtonClicked(transaction: TransactionModel) {
        let amountText = editTransactionView.amountTextField.text!
        
        guard !amountText.isEmpty else {
            showErrorAlert("Error!", "Amount is empty!")
            return
        }
        
        guard amountText.isNumber else {
            showErrorAlert("Error!", "The amount must contain only numbers!")
            return
        }
        
        delegate?.transactionEdited(transaction: transaction)
        dismiss(animated: true)
    }
    
}

// MARK: Select category delegate
extension EditTransactionViewControllerDeprecate: SelectCategoryViewControllerDelegate {
    
    func selectButtonClicked(category: CategoryModel?) {
        guard category != nil else { return }
		editTransactionView.selectedCategory = category ?? CategoriesManager.shared.defaultCategory
        editTransactionView.selectCategoryButton.setTitle(category?.title, for: .normal)
    }
    
}
