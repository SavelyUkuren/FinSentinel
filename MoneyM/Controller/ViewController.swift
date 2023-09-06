//
//  ViewController.swift
//  MoneyM
//
//  Created by Air on 30.08.2023.
//

import UIKit

class HomeViewController: UIViewController {

    private var homeView: HomeView!
    
    private var transactions: [TransactionModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeView = HomeView(frame: self.view.frame)
        homeView.setTransactionsTableViewDelegate(delegate: self)
        homeView.setTransactionsTableViewDataSource(dataSource: self)
        homeView.delegate = self
        
        self.view = homeView
        
    }


}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = transactions[indexPath.row].amount
        
        homeView.updateHeightTransactionTableView()
        return cell
    }
    
    
}

extension HomeViewController: HomeViewDelegate {
    
    func editBalanceButtonClicked() {
        let alert = UIAlertController(title: "Balance", message: "Edit balance", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = ""
            textField.keyboardType = .decimalPad
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            let textField = alert.textFields![0]
            self.homeView.startingBalance = Int(textField.text!) ?? 0
            self.homeView.reloadStats(transactions: self.transactions)
        }))
        
        present(alert, animated: true)
    }
    
    func datePickerButtonClicked() {
        let datePickerVC = DatePickerViewController()
        datePickerVC.delegate = self
        
        present(datePickerVC, animated: true)
    }
    
    func addNewTransactionButtonClicked() {
        let addTransactionVC = AddTransactionViewController()
        addTransactionVC.delegate = self
        
        present(addTransactionVC, animated: true)
    }
    
}

extension HomeViewController: TransactionCreated {
    
    func transactionCreated(transaction: TransactionModel) {
        transactions.append(transaction)
        homeView.reloadTransactionsTableView()
        homeView.reloadStats(transactions: transactions)
    }
    
}

extension HomeViewController: DatePickerDelegate {
    
    func chooseButtonClicked() {
        
    }
    
}
