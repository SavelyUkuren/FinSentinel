//
//  TransactionTableViewCell.swift
//  MoneyM
//
//  Created by Air on 02.09.2023.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

	enum Corner {

		case topLeft
		case topRight
		case bottomLeft
		case bottomRight

		var rawValue: CACornerMask {
			switch self {
			case .topLeft:
				CACornerMask.layerMinXMinYCorner
			case .topRight:
				CACornerMask.layerMaxXMinYCorner
			case .bottomLeft:
				CACornerMask.layerMinXMaxYCorner
			case .bottomRight:
				CACornerMask.layerMaxXMaxYCorner
			}
		}
	}

	@IBOutlet weak var categoryLabel: UILabel!

	@IBOutlet weak var amountLabel: UILabel!

	@IBOutlet weak var categoryImageView: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
		configureFont()
    }

    public func loadTransaction(transaction: TransactionModel) {

		let categoriesManager = CategoriesManager.shared
		let currencySymbol = Settings.shared.model.currency.symbol
		var categoryModel: CategoryProtocol = CategoriesManager.shared.defaultCategory

		let operatorSymbol = transaction.transactionType == .expense ? "-" : "+"
		let amount = transaction.amount.thousandSeparator

        amountLabel.text = "\(operatorSymbol)\(amount) \(currencySymbol)"
		
		if let foundedCategoryModel = categoriesManager.findCategory(id: transaction.categoryID ?? 0) {
			categoryModel = foundedCategoryModel
		}
		
		categoryLabel.text = categoryModel.title
		categoryImageView.image = UIImage(named: categoryModel.icon)
        
		amountLabel.textColor = transaction.transactionType == .expense ? .systemRed : .systemGreen

    }

	public func roundCorner(radius: CGFloat, corners: [Corner]) {
		layer.cornerRadius = radius

		let mask: CACornerMask = corners.reduce(into: CACornerMask()) { partialResult, corner in
			partialResult.insert(corner.rawValue)
		}
		layer.maskedCorners = mask
	}

	private func configureFont() {
		let font = CustomFonts()
		amountLabel.font = font.roundedFont(amountLabel.font.pointSize, .medium)
	}

}
