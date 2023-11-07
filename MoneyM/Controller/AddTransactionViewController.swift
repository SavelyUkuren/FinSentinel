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

class AddTransactionViewController: UIViewController {
    
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
        self.view = addTransactionView
    }
    
}

// MARK: Base transaction info delegate
extension AddTransactionViewController: TransactionEditorViewDelegate {
    
    func selectCategoryButtonClicked() {
        let selectCategoryVC = SelectCategoryViewController()
        selectCategoryVC.delegate = self
        selectCategoryVC.categoryType = addTransactionView.selectedMode
        
        present(selectCategoryVC, animated: true)
    }
    
    func confirmButtonClicked(transaction: TransactionModel) {
        delegate?.transactionCreated(transaction: transaction)
        
        dismiss(animated: true)
    }
    
}

// MARK: Select category delegate
extension AddTransactionViewController: SelectCategoryViewControllerDelegate {
    func selectButtonClicked(category: CategoryModel?) {
        guard category != nil else { return }
        addTransactionView.selectedCategory = category ?? CategoriesManager.defaultCategory
        addTransactionView.selectCategoryButton.setTitle(category?.title, for: .normal)
    }
}
