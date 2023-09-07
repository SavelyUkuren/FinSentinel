//
//  ViewController.swift
//  MoneyM
//
//  Created by Air on 30.08.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    class TransactionTableViewData {
        var section: DateComponents!
        var transactions: [TransactionModel]!
    }

    private var homeView: HomeView!
    
    private var transactions: [TransactionModel] = []
    
    private var tableViewData: [TransactionTableViewData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeView = HomeView(frame: self.view.frame)
        homeView.setTransactionsTableViewDelegate(delegate: self)
        homeView.setTransactionsTableViewDataSource(dataSource: self)
        homeView.delegate = self
        
        self.view = homeView
        
    }

    private func updateTransactionsTableView() {
        
        tableViewData.removeAll()
        
        let groupedTransactions = Dictionary(grouping: transactions) {
            let date = Calendar.current.dateComponents([.year, .month, .day], from: $0.date)
            return date
        }
        
        for (key, value) in groupedTransactions {
            let data = TransactionTableViewData()
            data.section = key
            data.transactions = value
            tableViewData.append(data)
        }
        
        tableViewData = tableViewData.sorted(by: { $0.section.day! < $1.section.day! })
        
        homeView.reloadTransactionsTableView()
        homeView.reloadStats(transactions: transactions)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TransactionTableViewCell
        
        let transaction = tableViewData[indexPath.section].transactions[indexPath.row]
        cell.amountLabel.text = transaction.amount
        
        homeView.updateHeightTransactionTableView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateComponent = tableViewData[section].section
        return "\(dateComponent!.day!) \(dateComponent!.month!)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
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

extension HomeViewController: AddTransactionViewControllerDelegate {
    
    func transactionCreated(transaction: TransactionModel) {
        transactions.append(transaction)
        updateTransactionsTableView()
    }
    
}

extension HomeViewController: DatePickerViewControllerDelegate {
    
    func chooseButtonClicked() {
        
    }
    
}
