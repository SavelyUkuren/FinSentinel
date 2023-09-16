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
    
    private var selectedMode: TransactionModel.Mode = .Expense
    private var transaction = TransactionModel()
    
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

extension AddTransactionViewController: BaseTransactionInfoViewDelegate {
    
    func confirmButtonClicked(transaction: TransactionModel) {
        delegate?.transactionCreated(transaction: transaction)
        
        dismiss(animated: true)
    }
    
}
