//
//  HomeViewControllerTableView.swift
//  MoneyM
//
//  Created by savik on 16.12.2023.
//

import Foundation
import UIKit

// MARK: - Table View Delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		scrollViewHeightConstraint.constant = tableView.contentSize.height
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		transactionsArray[section].transactions.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let transaction = transactionsArray[indexPath.section].transactions[indexPath.row]
		let cell: UITableViewCell?

		if transaction.note.isEmpty {
			cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell")
		} else {
			cell = tableView.dequeueReusableCell(withIdentifier: "cellWithNote")
		}

		if let defaultCell = cell as? TransactionTableViewCell {
			defaultCell.loadTransaction(transaction: transaction)
		} else if let cellWithNote = cell as? TransactionTableViewCellNote {
			cellWithNote.loadTransaction(transaction: transaction)
		}

		return cell ?? UITableViewCell()
	}

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let deleteAction = UIContextualAction(style: .destructive,
											  title: NSLocalizedString("delete.title", comment: "")) { _, _, _ in
			let transaction = self.transactionsArray[indexPath.section].transactions[indexPath.row]
			let request = Home.RemoveTransaction.Request(transaction: transaction)
			self.interactor?.removeTransaction(request: request)
		}

		let editAction = UIContextualAction(style: .normal,
											title: NSLocalizedString("edit.title", comment: "")) { _, _, _ in
			let transaction = self.transactionsArray[indexPath.section].transactions[indexPath.row]
			self.router?.routeToEditTransaction(transaction: transaction)
		}
		editAction.backgroundColor = .systemBlue

		let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction, editAction])

		return swipeAction
	}

	func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		return UIContextMenuConfiguration(identifier: nil,
								   previewProvider: nil) { _ in

			let editAction = UIAction(title: NSLocalizedString("edit.title", comment: ""),
									  image: UIImage(systemName: "pencil")) { _ in
				let transaction = self.transactionsArray[indexPath.section].transactions[indexPath.row]
				self.router?.routeToEditTransaction(transaction: transaction)
			}

			let deleteAction = UIAction(title: NSLocalizedString("delete.title", comment: ""),
										image: UIImage(systemName: "trash"),
										attributes: .destructive) { _ in
				let transaction = self.transactionsArray[indexPath.section].transactions[indexPath.row]
				let request = Home.RemoveTransaction.Request(transaction: transaction)
				self.interactor?.removeTransaction(request: request)
			}

			return UIMenu(children: [editAction, deleteAction])
		}
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		transactionsArray.count
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return transactionsArray[section].section
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		20
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		65
	}
}
