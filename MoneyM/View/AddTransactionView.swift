//
//  AddNewTransactionView.swift
//  MoneyM
//
//  Created by Air on 03.09.2023.
//

import UIKit

class AddTransactionView: BaseTransactionInfoView {
    
    public var delegate: BaseTransactionInfoViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        confirmButton.setTitle("Add", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configrmButtonClicked() {
        let transaction = TransactionModel()
        
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


