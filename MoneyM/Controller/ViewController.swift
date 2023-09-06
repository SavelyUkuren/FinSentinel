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
