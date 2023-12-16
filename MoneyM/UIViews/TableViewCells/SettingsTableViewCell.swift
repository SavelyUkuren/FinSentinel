//
//  SettingsTableViewCell.swift
//  MoneyM
//
//  Created by savik on 16.12.2023.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

	@IBOutlet weak var iconBackgroundView: UIView!
	
	@IBOutlet weak var iconImageView: UIImageView!
	
	@IBOutlet weak var titleLabel: UILabel!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
