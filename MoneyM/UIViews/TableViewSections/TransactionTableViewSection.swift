//
//  TransactionTableViewSection.swift
//  MoneyM
//
//  Created by Air on 29.10.2023.
//

import UIKit

class TransactionTableViewSection: UIView {
    
    public let dayLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 30))
        label.text = "0"
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let monthLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 30))
        label.text = "0"
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = UIStyle.TableViewCellBackgroundColor
        
        configureDayLabel()
        configureMonthLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureDayLabel() {
        addSubview(dayLabel)
        
        NSLayoutConstraint.activate([
            dayLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8)
        ])
    }
    
    private func configureMonthLabel() {
        addSubview(monthLabel)
        
        NSLayoutConstraint.activate([
            monthLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            monthLabel.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 4)
        ])
    }
    
}
