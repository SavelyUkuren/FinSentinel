//
//  CategoryTableViewCell.swift
//  MoneyM
//
//  Created by savik on 12.12.2023.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

	@IBOutlet weak var iconBackgroundView: UIView!
	
	@IBOutlet weak var iconImageView: UIImageView!
	
	@IBOutlet weak var categoryTitle: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		iconBackgroundView.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
