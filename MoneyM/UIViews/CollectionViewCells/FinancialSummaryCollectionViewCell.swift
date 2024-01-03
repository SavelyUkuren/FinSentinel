//
//  FinancialSummaryCollectionViewCell.swift
//  MoneyM
//
//  Created by savik on 03.01.2024.
//

import UIKit

class FinancialSummaryCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var titleLabel: UILabel!
	
	@IBOutlet weak var amountLabel: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureFonts()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configureFonts()
	}
	
	override func awakeFromNib() {
		configureFonts()
	}
	
	private func configureFonts() {
		let font = CustomFonts()
		
		if titleLabel != nil, amountLabel != nil {
			titleLabel.font = font.roundedFont(titleLabel.font.pointSize, .medium)
			amountLabel.font = font.roundedFont(amountLabel.font.pointSize, .bold)
		}
		
	}
	
}
