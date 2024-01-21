//
//  TransactionTableViewCell+Note.swift
//  MoneyM
//
//  Created by savik on 12.12.2023.
//

import UIKit

class TransactionTableViewCellNote: TransactionTableViewCell {

	@IBOutlet weak var noteLabel: UILabel!

	override func loadTransaction(transaction: TransactionModel) {
		super.loadTransaction(transaction: transaction)
		noteLabel.text = transaction.note
	}
}
