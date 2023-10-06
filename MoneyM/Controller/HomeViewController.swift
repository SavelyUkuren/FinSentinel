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
    
    private var currentDate: DateModel = DateModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCurrentDate()
        
        transactionModelManager = TransactionModelManager()
        transactionModelManager.loadData(dateModel: currentDate)
        
        homeView = HomeView(frame: self.view.frame)
        homeView.updateStatistics(statistic: transactionModelManager.statistics)
        homeView.setTransactionsTableViewDelegate(delegate: self)
        homeView.setTransactionsTableViewDataSource(dataSource: self)
        homeView.delegate = self
        homeView.setDateButtonTitle(dateModel: currentDate)
        
        self.view = homeView
        
        categories = Categories()
        //print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
    }
    
    private func loadCurrentDate() {
        let calendar = Calendar.current
        
        currentDate.month = calendar.component(.month, from: Date())
        currentDate.year = calendar.component(.year, from: Date())
        
    }
    
    private func editTransaction(indexPath: IndexPath) {
        let editTransactionVC = EditTransactionViewController()
        editTransactionVC.delegate = self
        editTransactionVC.transaction = self.transactionModelManager.data[indexPath.section].transactions[indexPath.row]
        
        self.present(editTransactionVC, animated: true)
    }
    
    private func deleteTransaction(indexPath: IndexPath) {
        transactionModelManager.removeTransaction(indexPath: indexPath)
        homeView.deleteTransaction(indexPath: [indexPath])
        
        // Remove section if transaction in this section is empty
        if transactionModelManager.data[indexPath.section].transactions.isEmpty {
            transactionModelManager.data.remove(at: indexPath.section)
            homeView.deleteDateSection(index: indexPath.section)
        }
        
        transactionModelManager.calculateStatistics()
        homeView.updateStatistics(statistic: transactionModelManager.statistics)
        homeView.updateHeightTransactionTableView()
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
            self.editTransaction(indexPath: indexPath)
        }
        editAction.backgroundColor = .systemBlue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [self] action, view, complitionHandler in
            self.deleteTransaction(indexPath: indexPath)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
}

// MARK: Home View Delegata
// This is where actions in HomeView are processing
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
        datePickerVC.dateModel = currentDate
        
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
        
        transactionModelManager.addTransaction(transaction: transaction, dateModel: currentDate)
        homeView.updateStatistics(statistic: transactionModelManager.statistics)
        homeView.reloadTransactionsTableView()
    }
    
}

// MARK: Edit Transaction Deletage
extension HomeViewController: EditTransactionViewControllerDelegate {
    
    func transactionEdited(transaction: TransactionModel) {
        transactionModelManager.editTransactionByID(id: transaction.id, newTransaction: transaction)
        homeView.updateStatistics(statistic: transactionModelManager.statistics)
        homeView.reloadTransactionsTableView()
    }
    
}

// MARK: Date Picker Delegate
extension HomeViewController: DatePickerViewControllerDelegate {
    func chooseButtonClicked(dateModel: DateModel) {
 
        currentDate = dateModel
        
        transactionModelManager.loadData(dateModel: dateModel)
        homeView.updateStatistics(statistic: transactionModelManager.statistics)
        homeView.reloadTransactionsTableView()
        homeView.setDateButtonTitle(dateModel: dateModel)
    }
    
}
