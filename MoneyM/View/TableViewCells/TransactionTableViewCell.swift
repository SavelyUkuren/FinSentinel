//
//  TransactionTableViewCell.swift
//  MoneyM
//
//  Created by Air on 02.09.2023.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        confiureCategoryLabel()
        configureAmountLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    private func confiureCategoryLabel() {
        contentView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    private func configureAmountLabel() {
        contentView.addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
