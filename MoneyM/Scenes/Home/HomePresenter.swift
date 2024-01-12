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
	func presentFinancialSummary(_ response: Home.FetchFinancialSummary.Response)
	func presentRemoveTransaction(_ response: Home.RemoveTransaction.Response)
	func presentAlertEditStartingBalance(_ response: Home.AlertEditStartingBalance.Response)
	func presentAlertDatePicker(_ response: Home.AlertDatePicker.Response)
	func presentDatePickerButton(_ response: Home.DatePickerButton.Response)
	func presentStartingBalance(_ response: Home.EditStartingBalance.Response)
}

// MARK: - Presentation logic
class HomePresenter: HomePresentationLogic {

	public var viewController: HomeDisplayLogic?

	init() {

	}

	func presentTransactions(_ response: Home.FetchTransactions.Response) {
//		let sortedData = response.data.sorted { $0.date > $1.date }
//		let result: [Home.TransactionTableViewCellModel] = sortedData.map { tData in
//			Home.TransactionTableViewCellModel(section: getDayAndMonth(tData.date),
//											   transactions: tData.transactions)
//		}
//
//		let viewModel = Home.FetchTransactions.ViewModel(data: result)
//		viewController?.displayTransactions(viewModel)
	}

	func presentFinancialSummary(_ response: Home.FetchFinancialSummary.Response) {
		
		let (startingBalance, balance, expense, income) = financialSumaryBeauty(financialSummary: response.summary)
		
		let viewModel = Home.FetchFinancialSummary.ViewModel(startingBalance: startingBalance,
															 balance: balance,
															 expense: expense,
															 income: income)
		viewController?.displayFinancialSummary(viewModel)
	}
	
	func presentStartingBalance(_ response: Home.EditStartingBalance.Response) {
		let (startingBalance, balance, expense, income) = financialSumaryBeauty(financialSummary: response.financialSummary)
		
		let viewModel = Home.EditStartingBalance.ViewModel(startingBalance: startingBalance,
															 balance: balance,
															 expense: expense,
															 income: income)
		viewController?.displayStartingBalance(viewModel)
	}

	func presentRemoveTransaction(_ response: Home.RemoveTransaction.Response) {
//		let result: [Home.TransactionTableViewCellModel] = response.data.map { tData in
//			Home.TransactionTableViewCellModel(section: getDayAndMonth(tData.date),
//											   transactions: tData.transactions)
//		}
//
//		let viewModel = Home.RemoveTransaction.ViewModel(data: result)
//		viewController?.displayRemoveTransaction(viewModel)
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

		let formatter = DateFormatter()
		formatter.dateFormat = "MMM y"

		let title = formatter.string(from: date ?? .now)

		let viewModel = Home.DatePickerButton.ViewModel(title: title)
		viewController?.displayDatePickerButton(viewModel)
	}

	private func getDayAndMonth(_ date: Date) -> String {

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d MMMM"

		return dateFormatter.string(from: date)
	}
	
	private func financialSumaryBeauty(financialSummary: FinancialSummaryModel) -> (startingBalance: FinancialSummaryCellModel,
																			   balance: FinancialSummaryCellModel,
																			   expense: FinancialSummaryCellModel,
																			   income: FinancialSummaryCellModel) {
		let currency = Settings.shared.model.currency.symbol

		let expenseOperator = abs(financialSummary.expense) == 0 ? "" : "-"
		let incomeOperator = financialSummary.income == 0 ? "" : "+"
		
		let startingBalance = financialSummary.startingBalance
		let balance = financialSummary.balance
		let expense = abs(financialSummary.expense)
		let income = financialSummary.income

		let startingBalanceString = "\(startingBalance.thousandSeparator) \(currency)"
		let balanceString = "\(balance.thousandSeparator) \(currency)"
		let expenseString = "\(expenseOperator)\(expense.thousandSeparator) \(currency)"
		let incomeString = "\(incomeOperator)\(income.thousandSeparator) \(currency)"

		let balanceColor: UIColor = financialSummary.balance < 0 ? .systemRed : .systemGreen

		let startingBalanceFSCM = FinancialSummaryCellModel(title: NSLocalizedString("starting_balance.title", comment: ""),
														   amount: startingBalanceString,
														   amountColor: .systemGreen)
		let balanceFSCM = FinancialSummaryCellModel(title: NSLocalizedString("balance.title", comment: ""),
														   amount: balanceString,
														   amountColor: balanceColor)
		let expenseFSCM = FinancialSummaryCellModel(title: NSLocalizedString("expense.title", comment: ""),
														   amount: expenseString,
														   amountColor: .systemRed)
		let incomeFSCM = FinancialSummaryCellModel(title: NSLocalizedString("income.title", comment: ""),
														   amount: incomeString,
														   amountColor: .systemGreen)
		
		return (startingBalanceFSCM, balanceFSCM, expenseFSCM, incomeFSCM)
	}

}
