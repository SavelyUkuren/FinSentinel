//
//  ViewController.swift
//  MoneyM
//
//  Created by Air on 30.08.2023.
//

import UIKit

class HomeViewController: UIViewController {

    private var homeView: HomeView!
    
    private var transactionModelManager: TransactionModelManager!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var categories: Categories!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionModelManager = TransactionModelManager()
        
        homeView = HomeView(frame: self.view.frame)
        homeView.updateStatistics(statistic: transactionModelManager.statistics)
        homeView.setTransactionsTableViewDelegate(delegate: self)
        homeView.setTransactionsTableViewDataSource(dataSource: self)
        homeView.delegate = self
        
        self.view = homeView
        
        categories = Categories()
        
    }
}

// MARK: Table View
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionModelManager.data[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TransactionTableViewCell
        
        let transaction = transactionModelManager.data[indexPath.section].transactions[indexPath.row]
        cell.amountLabel.text = transaction.amount
        cell.categoryLabel.text = transaction.category.title
        
        homeView.updateHeightTransactionTableView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateComponent = transactionModelManager.data[section].section
        return "\(dateComponent!.day!) \(dateComponent!.month!)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionModelManager.data.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { action, view, complitionHandler in
            let editTransactionVC = EditTransactionViewController()
            editTransactionVC.delegate = self
            editTransactionVC.transaction = self.transactionModelManager.data[indexPath.section].transactions[indexPath.row]
            
            self.present(editTransactionVC, animated: true)
        }
        editAction.backgroundColor = .systemBlue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [self] action, view, complitionHandler in
            
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
}

// MARK: Home View Delegata
extension HomeViewController: HomeViewDelegate {
    
    func editBalanceButtonClicked() {
        let alert = UIAlertController(title: "Balance", message: "Edit balance", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = ""
            textField.keyboardType = .decimalPad
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            let textField = alert.textFields![0]
            self.transactionModelManager.startingBalance = Int(textField.text!) ?? 0
            self.transactionModelManager.calculateStatistics()
            self.homeView.updateStatistics(statistic: self.transactionModelManager.statistics)
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

// MARK: Add Transaction Delegate
extension HomeViewController: AddTransactionViewControllerDelegate {
    
    func transactionCreated(transaction: TransactionModel) {
        
        transactionModelManager.addTransaction(transaction: transaction)
        homeView.updateStatistics(statistic: transactionModelManager.statistics)
        homeView.reloadTransactionsTableView()
    }
    
}

// MARK: Edit Transaction Deletage
extension HomeViewController: EditTransactionViewControllerDelegate {
    
    func transactionEdited(transaction: TransactionModel) {
        
    }
    
}

// MARK: Date Picker Delegate
extension HomeViewController: DatePickerViewControllerDelegate {
    
    func chooseButtonClicked() {
        
    }
    
}
