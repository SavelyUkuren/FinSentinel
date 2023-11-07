//
//  EditTransactionView.swift
//  MoneyM
//
//  Created by Air on 16.09.2023.
//

import UIKit

class EditTransactionView: TransactionEditorView {
    
    private var transactionID: Int = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        confirmButton.setTitle("Edit", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func loadTransaction(transaction: TransactionModel) {
        
        amountTextField.text = "\(transaction.amount!)"
        datePicker.date = transaction.date
        selectedMode = transaction.mode
        selectedCategory = CategoriesManager.shared.findCategoryBy(id: transaction.categoryID) ?? selectedCategory
        transactionID = transaction.id
        
        selectCategoryButton.setTitle(selectedCategory.title, for: .normal)
        
        switch selectedMode {
        case .Expense:
            choiceModeButton.selectButton(.First)
        case .Income:
            choiceModeButton.selectButton(.Second)
        }
        
    }

    override func configrmButtonClicked() {
        
        let transaction = TransactionModel()
        
        transaction.id = transactionID
        transaction.mode = selectedMode
        transaction.date = datePicker.date
        transaction.categoryID = selectedCategory.id
        transaction.amount = Int(amountTextField.text!)
        
        delegate?.confirmButtonClicked(transaction: transaction)
    }
    
    override func selectCategoryButtonClicked() {
        delegate?.selectCategoryButtonClicked()
    }
    
}
