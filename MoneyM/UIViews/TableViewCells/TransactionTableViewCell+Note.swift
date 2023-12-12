//
//  TransactionTableViewCell+Note.swift
//  MoneyM
//
//  Created by savik on 12.12.2023.
//

import UIKit

class TransactionTableViewCell_Note: TransactionTableViewCell {

	@IBOutlet weak var noteLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func loadTransaction(transaction: TransactionModel) {
		super.loadTransaction(transaction: transaction)
		noteLabel.text = transaction.note
	}
}
