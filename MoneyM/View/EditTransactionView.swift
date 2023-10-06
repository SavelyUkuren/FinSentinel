//
//  EditTransactionView.swift
//  MoneyM
//
//  Created by Air on 16.09.2023.
//

import UIKit

class EditTransactionView: BaseTransactionInfoView {
    
    public var delegate: BaseTransactionInfoViewDelegate?
    
    private var transactionID: Int = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        confirmButton.setTitle("Edit", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func loadTransaction(transaction: TransactionModel) {
        
        amountTextField.text = transaction.amount
        datePicker.date = transaction.date
        selectedMode = transaction.mode
        selectedCategory = categories.findCategoryByID(id: transaction.category.id)!
        transactionID = transaction.id
        
        selectCategoryButton.setTitle(selectedCategory.title, for: .normal)
        
        switch selectedMode {
        case .Expense:
            expenseButtonClicked()
        case .Income:
            incomeButtonClicked()
        }
        
    }

    override func configrmButtonClicked() {
        
        let transaction = TransactionModel()
        
        transaction.id = transactionID
        transaction.mode = selectedMode
        transaction.date = datePicker.date
        transaction.category = selectedCategory
        transaction.amount = amountTextField.text
        
        delegate?.confirmButtonClicked(transaction: transaction)
    }
    
    override func selectCategoryButtonClicked() {
        delegate?.selectCategoryButtonClicked()
    }
    
}
