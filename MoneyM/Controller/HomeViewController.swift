//
//  ViewController.swift
//  MoneyM
//
//  Created by Air on 30.08.2023.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    
    private var homeView: HomeView!
    
    private var transactionModelManager: TransactionModelManager!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var currentDate: DateModel = DateModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configureNavigationBar()
        
        loadCurrentDate()
        
        transactionModelManager = TransactionModelManager()
        transactionModelManager.loadData(dateModel: currentDate)
        printFinancialSummary()
        
        homeView = HomeView(frame: self.view.frame)
        updateHomeView()
        homeView.setTransactionsTableViewDelegate(delegate: self)
        homeView.setTransactionsTableViewDataSource(dataSource: self)
        homeView.delegate = self
        homeView.setDateButtonTitle(dateModel: currentDate)
        
        self.view = homeView
		
		addNotificationObservers()
        
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        
		configureSettingsButton()
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
        
        updateHomeView()
        homeView.updateHeightTransactionTableView()
    }
    
    private func printFinancialSummary() {
        print ("Balance: \(transactionModelManager.financialSummary.balance)")
        print ("Expense: \(transactionModelManager.financialSummary.expense)")
        print ("Income: \(transactionModelManager.financialSummary.income)")
    }
	
	private func configureNavigationBar() {
		title = "MoneyM"
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	private func configureSettingsButton() {
		let button = UIBarButtonItem(image: UIImage(systemName: "gear"),
									 style: .plain, target: self,
									 action: #selector(settingsButtonClicked))
		button.tintColor = Settings.shared.model.accentColor
		navigationItem.rightBarButtonItem = button
	}
    
    @objc
	private func updateHomeView() {
        let summary = transactionModelManager.financialSummary!
		let currency = Settings.shared.model.currency!
        
        homeView.updateBalanceLabel(amount: summary.balance, currency: currency)
        homeView.updateExpenseLabel(amount: summary.expense, currency: currency)
        homeView.updateIncomeLabel(amount: summary.income, currency: currency)
        
        homeView.reloadTransactionsTableView()
    }
	
	@objc
	private func changeAccentColor() {
		homeView.setAccentColor(Settings.shared.model.accentColor)
		navigationItem.rightBarButtonItem?.tintColor = Settings.shared.model.accentColor
	}
    
	private func addNotificationObservers() {
		// Currency changed
		NotificationCenter.default.addObserver(self, selector: #selector(updateHomeView),
											   name: Settings.shared.notificationCurrencyChange, object: nil)
		
		// Accent color changed
		NotificationCenter.default.addObserver(self, selector: #selector(changeAccentColor),
											   name: Settings.shared.notificationAccentColorChange, object: nil)
	}
	
	@objc
	private func settingsButtonClicked() {
		
		let settingsVC = UIHostingController(rootView: SettingsView())
		navigationController?.pushViewController(settingsVC, animated: true)
		
	}
	
}

// MARK: Table View
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIStyle.TransactionTableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UIStyle.TransactionTableViewSectionHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionModelManager.data[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TransactionTableViewCell
        
        let transaction = transactionModelManager.data[indexPath.section].transactions[indexPath.row]
        
        cell.loadTransaction(transaction: transaction)
        
        homeView.updateHeightTransactionTableView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateModelManager = DateModelManager()
        
        let dateComponent = transactionModelManager.data[section].section
        let day = dateComponent!.day!
        let month = dateModelManager.getMonthTitle(byMontNumber: dateComponent!.month!) ?? ""
        
        return "\(day) \(month)"
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TransactionTableViewSection(frame: CGRect(x: 0, y: 0,
                                                             width: tableView.frame.width,
                                                             height: UIStyle.TransactionTableViewSectionHeight))
        
        let dateModelManager = DateModelManager()
        
        let dateComponent = transactionModelManager.data[section].section
        let day = dateComponent!.day!
        let month = dateModelManager.getMonthTitle(byMontNumber: dateComponent!.month!) ?? ""
        
        view.dayLabel.text = String(day)
        view.monthLabel.text = month
        
        return view
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
            self.updateHomeView()
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
        updateHomeView()
    }
    
}

// MARK: Edit Transaction Deletage
extension HomeViewController: EditTransactionViewControllerDelegate {
    
    func transactionEdited(transaction: TransactionModel) {
        transactionModelManager.editTransactionByID(id: transaction.id, newTransaction: transaction)
        updateHomeView()
    }
    
}

// MARK: Date Picker Delegate
extension HomeViewController: DatePickerViewControllerDelegate {
    func chooseButtonClicked(dateModel: DateModel) {
 
        currentDate = dateModel
        
        transactionModelManager.loadData(dateModel: dateModel)
        updateHomeView()
        homeView.setDateButtonTitle(dateModel: dateModel)
    }
    
}
