//
//  HomePresenter.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//

import Foundation
import UIKit

protocol HomePresentationLogic {
	func presentTransactions(_ response: Home.FetchTransactions.Response)
	func presentAddedTransaction(_ response: Home.AddTransaction.Response)
	func presentFinancialSummary(_ response: Home.FetchFinancialSummary.Response)
	func presentEditedTransaction(_ response: Home.EditTransaction.Response)
	func presentRemoveTransaction(_ response: Home.RemoveTransaction.Response)
	func presentAlertEditStartingBalance(_ response: Home.AlertEditStartingBalance.Response)
	func presentAlertDatePicker(_ response: Home.AlertDatePicker.Response)
	func presentDatePickerButton(_ response: Home.DatePickerButton.Response)
	func presentStartingBalance(_ response: Home.EditStartingBalance.Response)
}

// MARK: - Presentation logic
class HomePresenter {

	public var viewController: HomeDisplayLogic?

	init() {

	}

	private func getDayAndMonth(_ date: Date) -> String {

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d MMMM"

		return dateFormatter.string(from: date)
	}

	private func groupTransactionsByDay(_ transactions: [TransactionModel]) -> [(key: DateComponents, value: [TransactionModel])] {
		return Dictionary(grouping: transactions, by: { transaction in
			
			Calendar.current.dateComponents([.day, .month], from: transaction.dateOfCreation)
			
		}).sorted(by: { $0.key.day! > $1.key.day! })
	}
	
	// Transform dictionary grouped transactions by day to TransactionTableViewCellModel
	private func transformToTransactionTableViewCellModel(_ groupedTransactions: [(key: DateComponents, value: [TransactionModel])]) -> [TransactionTableViewCellModel] {
		return groupedTransactions.map { (key: DateComponents, value: [TransactionModel]) in
			let date = Calendar.current.date(from: key)
			let dayAndMonthName = getDayAndMonth(date!)
			
			return TransactionTableViewCellModel(section: "\(dayAndMonthName)",
										  transactions: value)
		}
	}
	
	private func financialSummaryBeauty(_ financialSummary: FinancialSummaryModel) -> (FinancialSummaryCellModel,
																					   FinancialSummaryCellModel,
																					   FinancialSummaryCellModel,
																					   FinancialSummaryCellModel) {
		let beautifier = FinancialSummaryBeautifier()
		beautifier.financialSummary = financialSummary
		
		let beautifierError = "Beautifier error"
		
		let startingBalance = beautifier.startingBalance ?? beautifierError
		let balance = beautifier.balance ?? beautifierError
		let expense = beautifier.expense ?? beautifierError
		let income = beautifier.income ?? beautifierError
		
		let startingBalanceFSCM = FinancialSummaryCellModel(title: NSLocalizedString("starting_balance.title", comment: ""),
															amount: startingBalance,
															amountColor: beautifier.startingBalanceColor)
		let balanceFSCM = FinancialSummaryCellModel(title: NSLocalizedString("balance.title", comment: ""),
													amount: balance,
													amountColor: beautifier.balanceColor)
		let expenseFSCM = FinancialSummaryCellModel(title: NSLocalizedString("expense.title", comment: ""),
													amount: expense,
													amountColor: beautifier.expenseColor)
		let incomeFSCM = FinancialSummaryCellModel(title: NSLocalizedString("income.title", comment: ""),
												   amount: income,
												   amountColor: beautifier.incomeColor)
		
		return (startingBalanceFSCM, balanceFSCM, expenseFSCM, incomeFSCM)
	}
	
}

// MARK: - HomePresent Logic
extension HomePresenter: HomePresentationLogic {
	func presentTransactions(_ response: Home.FetchTransactions.Response) {
		let groupedTransactionsByDay = groupTransactionsByDay(response.transactions)
		let transactionCellModels = transformToTransactionTableViewCellModel(groupedTransactionsByDay)

		let viewModel = Home.FetchTransactions.ViewModel(data: transactionCellModels)
		viewController?.displayTransactions(viewModel)
	}
	
	func presentAddedTransaction(_ response: Home.AddTransaction.Response) {
		let groupedTransactionsByDay = groupTransactionsByDay(response.transactions)
		let transactionCellModels = transformToTransactionTableViewCellModel(groupedTransactionsByDay)
		
		let viewModel = Home.AddTransaction.ViewModel(data: transactionCellModels)
		viewController?.displayAddedTransaction(viewModel)
	}
	
	func presentEditedTransaction(_ response: Home.EditTransaction.Response) {
		let groupedTransactionsByDay = groupTransactionsByDay(response.transactions)
		let transactionCellModels = transformToTransactionTableViewCellModel(groupedTransactionsByDay)
		
		let viewModel = Home.EditTransaction.ViewModel(data: transactionCellModels)
		viewController?.displayEditedTransaction(viewModel)
	}

	func presentFinancialSummary(_ response: Home.FetchFinancialSummary.Response) {
		
		let (startingBalance, balance, expense, income) = financialSummaryBeauty(response.summary)
		
		let viewModel = Home.FetchFinancialSummary.ViewModel(startingBalance: startingBalance,
															 balance: balance,
															 expense: expense,
															 income: income)
		viewController?.displayFinancialSummary(viewModel)
	}
	
	func presentStartingBalance(_ response: Home.EditStartingBalance.Response) {
		let (startingBalance, balance, expense, income) = financialSummaryBeauty(response.financialSummary)
		
		let viewModel = Home.EditStartingBalance.ViewModel(startingBalance: startingBalance,
															 balance: balance,
															 expense: expense,
															 income: income)
		viewController?.displayStartingBalance(viewModel)
	}

	func presentRemoveTransaction(_ response: Home.RemoveTransaction.Response) {
		let groupedTransactionsByDay = groupTransactionsByDay(response.transactions)
		let transactionCellModels = transformToTransactionTableViewCellModel(groupedTransactionsByDay)

		let viewModel = Home.RemoveTransaction.ViewModel(data: transactionCellModels)
		viewController?.displayRemoveTransaction(viewModel)
	}

	func presentAlertEditStartingBalance(_ response: Home.AlertEditStartingBalance.Response) {
		let alert = UIAlertController(title: NSLocalizedString("edit_starting_balance.title", comment: ""),
									  message: nil,
									  preferredStyle: .alert)

		alert.addTextField { textField in
			textField.placeholder = NSLocalizedString("balance.title", comment: "")
			textField.keyboardType = .decimalPad
		}

		alert.addAction(UIAlertAction(title: NSLocalizedString("edit.title", comment: ""),
									  style: .default,
									  handler: {_ in
			let balance = alert.textFields?[0].text ?? ""
			response.action(balance)
		}))

		let viewModel = Home.AlertEditStartingBalance.ViewModel(alert: alert)
		viewController?.displayAlertEditStartingBalance(viewModel)
	}

	func presentAlertDatePicker(_ response: Home.AlertDatePicker.Response) {
		let datePickerVC = UIViewController()
		let pickerView = MonthYearWheelPicker()
		pickerView.minimumDate = Date(timeIntervalSince1970: 0)
		pickerView.maximumDate = .now

		datePickerVC.view = pickerView

		let alert = UIAlertController(title: NSLocalizedString("select_date.title", comment: ""), message: nil, preferredStyle: .actionSheet)
		alert.setValue(datePickerVC, forKey: "contentViewController")

		let selectAction = UIAlertAction(title: NSLocalizedString("select.title", comment: ""), style: .default) { _ in
			response.action(pickerView.month, pickerView.year)
		}

		let cancelAction = UIAlertAction(title: NSLocalizedString("cancel.title", comment: ""), style: .destructive) {_ in
			alert.dismiss(animated: true)
		}

		alert.addAction(selectAction)
		alert.addAction(cancelAction)

		let viewModel = Home.AlertDatePicker.ViewModel(alert: alert)
		viewController?.displayAlertDatePicker(viewModel)
	}

	func presentDatePickerButton(_ response: Home.DatePickerButton.Response) {

		var dateComponents = DateComponents()
		dateComponents.month = response.month
		dateComponents.year = response.year

		let date = Calendar.current.date(from: dateComponents)
		
		let title = switch date {
		case .none:
			   "\(response.month) \(response.year)"
		case .some(_):
			"\(date!.monthTitle) \(response.year)"
	   }

		let viewModel = Home.DatePickerButton.ViewModel(title: title)
		viewController?.displayDatePickerButton(viewModel)
	}
}
