//
//  HomePresenter.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//

import Foundation

protocol HomePresentationLogic {
	func presentTransactions(_ response: Home.FetchTransactions.Response)
}

// MARK: - Presentation logic
class HomePresenter: HomePresentationLogic {
	
	var viewController: HomeDisplayLogic?
	
	init() {
		
	}
	
	func presentTransactions(_ response: Home.FetchTransactions.Response) {
		var data: [Home.TransactionTableViewCellModel] = []
		
		data = groupingTransactionsByDate(response.data)
		
		let viewModel = Home.FetchTransactions.ViewModel(data: data)
		viewController?.displayTransactions(viewModel)
	}
	
	private func groupingTransactionsByDate(_ transactions: [TransactionModel]) -> [Home.TransactionTableViewCellModel] {
		var arr: [Home.TransactionTableViewCellModel] = []
		
		let groupedTransactions = Dictionary(grouping: transactions) {
			let date = Calendar.current.dateComponents([.year, .month, .day], from: $0.date)
			return date
		}
		
		for (key, value) in groupedTransactions {
			var temp = Home.TransactionTableViewCellModel(section: "\(key.day!) \(key.month!)",
														  transactions: value)
			temp.transactions = temp.transactions.sorted { $0.date > $1.date }
			arr.append(temp)
		}
		
//		arr = arr.sorted(by: { $0.section.day! < $1.section.day! })
		
		return arr
	}
	
}
