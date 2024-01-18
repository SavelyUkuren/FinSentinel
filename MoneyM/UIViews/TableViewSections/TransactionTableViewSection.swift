//
//  TransactionTableViewSection.swift
//  MoneyM
//
//  Created by Air on 29.10.2023.
//

import UIKit

class TransactionTableViewSection: UIView {
	
	public let dateLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 30))
        label.text = "Label"
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .secondaryLabel
        return label
	}()
	
	public let totalAmountLabel: UILabel = {
		let label = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 30))
		label.text = "Total amount"
		label.font = CustomFonts().roundedFont(14, .medium)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .secondaryLabel
		return label
	}()
	
	public var totalAmount: Double = 0 {
		didSet {
			let currencySymbol = Settings.shared.model.currency.symbol
			totalAmountLabel.text = "\(totalAmount.thousandSeparator) \(currencySymbol)"
			totalAmountLabel.textColor = totalAmount < 0 ? .systemRed : .systemGreen
		}
	}

    override init(frame: CGRect) {
        super.init(frame: frame)
		
		configureDateLabel()
		configureTotalAmountLabel()
		
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
	
	private func configureDateLabel() {
		addSubview(dateLabel)
		
		NSLayoutConstraint.activate([
			dateLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
			dateLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16)
		])
	}
	
	private func configureTotalAmountLabel() {
		addSubview(totalAmountLabel)
		
		NSLayoutConstraint.activate([
			totalAmountLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
			totalAmountLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
		])
	}

}
