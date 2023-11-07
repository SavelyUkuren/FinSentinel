//
//  EditTransactionViewController.swift
//  MoneyM
//
//  Created by Air on 16.09.2023.
//

import UIKit

protocol EditTransactionViewControllerDelegate {
    func transactionEdited(transaction: TransactionModel)
}

class EditTransactionViewController: UIViewController {
    
    public var delegate: EditTransactionViewControllerDelegate?

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

}

// MARK: Base transaction info delegate
extension EditTransactionViewController: BaseTransactionInfoViewDelegate {
    
    func selectCategoryButtonClicked() {
        let selectCategoryVC = SelectCategoryViewController()
        selectCategoryVC.delegate = self
        selectCategoryVC.categoryType = editTransactionView.selectedMode
        
        present(selectCategoryVC, animated: true)
    }
    
    func confirmButtonClicked(transaction: TransactionModel) {
        delegate?.transactionEdited(transaction: transaction)
        dismiss(animated: true)
    }
    
}

// MARK: Select category delegate
extension EditTransactionViewController: SelectCategoryViewControllerDelegate {
    
    func selectButtonClicked(category: CategoryModel?) {
        guard category != nil else { return }
        editTransactionView.selectedCategory = category ?? CategoriesManager.defaultCategory
        editTransactionView.selectCategoryButton.setTitle(category?.title, for: .normal)
    }
    
}
