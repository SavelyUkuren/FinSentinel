//
//  AddNewTransactionView.swift
//  MoneyM
//
//  Created by Air on 03.09.2023.
//

import UIKit

class AddTransactionView: TransactionEditorView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        confirmButton.setTitle("Add", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configrmButtonClicked() {
        super.configrmButtonClicked()
        
        let transaction = TransactionModel()
        
        transaction.mode = selectedMode
        transaction.date = datePicker.date
        transaction.categoryID = selectedCategory.id
        transaction.amount = Int(amountTextField.text!)
        
        delegate?.confirmButtonClicked(transaction: transaction)
    }
    
    override func selectCategoryButtonClicked() {
        super.selectCategoryButtonClicked()
        
        delegate?.selectCategoryButtonClicked()
    }
    
}
