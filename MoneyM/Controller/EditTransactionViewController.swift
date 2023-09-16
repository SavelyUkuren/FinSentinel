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

        editTransactionView = EditTransactionView(frame: view.frame)
        editTransactionView.translatesAutoresizingMaskIntoConstraints = false
        editTransactionView.delegate = self
        
        view = editTransactionView
        
        editTransactionView.loadTransaction(transaction: transaction)
    }

}

extension EditTransactionViewController: BaseTransactionInfoViewDelegate {
    
    func selectCategoryButtonClicked() {
        
    }
    
    func confirmButtonClicked(transaction: TransactionModel) {
        delegate?.transactionEdited(transaction: transaction)
        dismiss(animated: true)
    }
    
}
