//
//  EditTransactionView.swift
//  MoneyM
//
//  Created by Air on 16.09.2023.
//

import UIKit

class EditTransactionView: BaseTransactionInfoView {
    
    public var delegate: BaseTransactionInfoViewDelegate?
    
    private var transaction: TransactionModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        confirmButton.setTitle("Edit", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func loadTransaction(transaction: TransactionModel) {
        self.transaction = transaction
        
        amountTextField.text = transaction.amount
        datePicker.date = transaction.date
        selectedMode = transaction.mode
        
        switch selectedMode {
        case .Expense:
            expenseButtonClicked()
        case .Income:
            incomeButtonClicked()
        }
        
    }

    override func configrmButtonClicked() {
        
        transaction.mode = selectedMode
        transaction.date = datePicker.date
        transaction.category = CategoryModel(id: -1, title: "")
        transaction.amount = amountTextField.text
        
        delegate?.confirmButtonClicked(transaction: transaction)
    }
    
}
