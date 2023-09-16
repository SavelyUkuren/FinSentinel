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
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeView = HomeView(frame: self.view.frame)
        homeView.setTransactionsTableViewDelegate(delegate: self)
        homeView.setTransactionsTableViewDataSource(dataSource: self)
        homeView.delegate = self
        
        self.view = homeView
        
        loadFromCoreDataToTransactionsArray()
        updateTransactionsTableView()
    }
    
    public func loadFromCoreDataToTransactionsArray() {
        
        let fetchRequest = TransactionEntity.fetchRequest()
        
        do {
            let requestedTransactions = try context.fetch(fetchRequest)
            
            for transaction in requestedTransactions {
                let newTransaction = TransactionModel()
                newTransaction.id = Int(transaction.id)
                newTransaction.amount = "\(transaction.amount)"
                newTransaction.category = transaction.category
                newTransaction.date = transaction.date
                newTransaction.mode = TransactionModel.Mode(rawValue: Int(transaction.mode))
                
                transactions.append(newTransaction)
            }
            
        } catch {
            fatalError("Error with load data")
        }
        
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { action, view, complitionHandler in
            let editTransactionVC = EditTransactionViewController()
            editTransactionVC.delegate = self
            editTransactionVC.transaction = self.tableViewData[indexPath.section].transactions[indexPath.row]
            
            self.present(editTransactionVC, animated: true)
        }
        editAction.backgroundColor = .systemBlue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [self] action, view, complitionHandler in
            let removed = tableViewData[indexPath.section].transactions.remove(at: indexPath.row)
            if let index = transactions.firstIndex(where: { $0.id == removed.id }) {
                transactions.remove(at: index)
            }

            homeView.deleteTransaction(indexPath: [indexPath])
            homeView.reloadStats(transactions: transactions)

            if tableViewData[indexPath.section].transactions.isEmpty {
                tableViewData.remove(at: indexPath.section)
                homeView.deleteDateSection(index: indexPath.section)
            }

            updateTransactionsTableView()

            //Remove from Core Data
            let fetchRequest = TransactionEntity.fetchRequest()
            do {
                let requestedData = try context.fetch(fetchRequest)
                let transactionEntity = requestedData.first { entity in
                    entity.id == removed.id
                }

                context.delete(transactionEntity!)

                try context.save()
            } catch {
                fatalError("Error with remove transaction in Core Data")
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
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
        transaction.id = transactions.count
        transactions.append(transaction)
        
        let transactionEntity = TransactionEntity(context: context)
        transactionEntity.id = Int16(transaction.id)
        transactionEntity.amount = Int16(transaction.amount) ?? 0
        transactionEntity.category = transaction.category
        transactionEntity.date = transaction.date
        transactionEntity.mode = Int16(transaction.mode.rawValue)
        
        do {
            try context.save()
        } catch {
            fatalError("Error with saving transaction")
        }
        
        updateTransactionsTableView()
    }
    
}

extension HomeViewController: EditTransactionViewControllerDelegate {
    
    func transactionEdited(transaction: TransactionModel) {
        let transactionForEdit = transactions.first { $0.id == transaction.id }
        
        transactionForEdit?.amount = transaction.amount
        transactionForEdit?.date = transaction.date
        transactionForEdit?.mode = transaction.mode
        transactionForEdit?.category = transaction.category
        
        updateTransactionsTableView()
        
        // Core Data
        let fetchRequest = TransactionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", transaction.id)
        
        do {
            let requestedTransaction = try context.fetch(fetchRequest)
            
            if let t = requestedTransaction.first {
                t.amount = Int16(transaction.amount) ?? 0
                t.date = transaction.date
                t.category = transaction.category
                t.mode = Int16(transaction.mode.rawValue)
                
                try context.save()
            }
            
        } catch {
            fatalError("Error with edit transaction")
        }
    }
    
}

extension HomeViewController: DatePickerViewControllerDelegate {
    
    func chooseButtonClicked() {
        
    }
    
}
