//
//  AddTransactionViewController.swift
//  MoneyM
//
//  Created by Air on 03.09.2023.
//

import UIKit

class AddTransactionViewController: UIViewController {
    
    private var addTransactionView: AddTransactionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureAddTransactionView()
    }

    private func configureAddTransactionView() {
        addTransactionView = AddTransactionView(frame: view.frame)
        addTransactionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view = addTransactionView
    }
    
}

extension AddTransactionViewController: AddTransactionDelegate {
    
    func addTransactionButtonClicked() {
        
    }
    
}
