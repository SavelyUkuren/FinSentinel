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
}

// MARK: - Presentation logic
class HomePresenter: HomePresentationLogic {

	var viewController: HomeDisplayLogic?

	init() {

	}

	func presentTransactions(_ response: Home.FetchTransactions.Response) {
		let sortedData = response.data.sorted { $0.date > $1.date }
		let result: [Home.TransactionTableViewCellModel] = sortedData.map { tData in
			Home.TransactionTableViewCellModel(section: getDayAndMonth(tData.date),
											   transactions: tData.transactions)
		}

		let viewModel = Home.FetchTransactions.ViewModel(data: result)
		viewController?.displayTransactions(viewModel)
	}

	func presentFinancialSummary(_ response: Home.FetchFinancialSummary.Response) {
		let currency = Settings.shared.model.currency.symbol

		let expenseOperator = abs(response.summary.expense) == 0 ? "" : "-"
		let incomeOperator = response.summary.income == 0 ? "" : "+"
		let balance = response.summary.balance
		let expense = abs(response.summary.expense)
		let income = response.summary.income

		let balanceString = "\(balance.thousandSeparator) \(currency)"
		let expenseString = "\(expenseOperator)\(expense.thousandSeparator) \(currency)"
		let incomeString = "\(incomeOperator)\(income.thousandSeparator) \(currency)"

		let balanceColor: UIColor = response.summary.balance < 0 ? .systemRed : .systemGreen

		let viewModel = Home.FetchFinancialSummary.ViewModel(balanceColor: balanceColor,
															 balance: balanceString,
															 expense: expenseString,
															 income: incomeString)
		viewController?.displayFinancialSummary(viewModel)
	}

	func presentRemoveTransaction(_ response: Home.RemoveTransaction.Response) {
		let result: [Home.TransactionTableViewCellModel] = response.data.map { tData in
			Home.TransactionTableViewCellModel(section: getDayAndMonth(tData.date),
											   transactions: tData.transactions)
		}

		let viewModel = Home.RemoveTransaction.ViewModel(data: result)
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
		alert.addAction(selectAction)

		let viewModel = Home.AlertDatePicker.ViewModel(alert: alert)
		viewController?.displayAlertDatePicker(viewModel)
	}

	private func getDayAndMonth(_ date: Date) -> String {

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d MMMM"

		return dateFormatter.string(from: date)
	}

}
