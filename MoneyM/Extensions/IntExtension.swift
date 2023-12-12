//
//  IntExtension.swift
//  MoneyM
//
//  Created by savik on 12.12.2023.
//

import Foundation

extension Int {
	var thousandSeparator: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		
		return formatter.string(from: NSNumber(value: self)) ?? ""
	}
}
