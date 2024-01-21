//
//  IntExtension.swift
//  MoneyM
//
//  Created by savik on 12.12.2023.
//

import Foundation

extension Double {
	var thousandSeparator: String {
		let formatter = NumberFormatter()
		//formatter.usesGroupingSeparator = true
		formatter.numberStyle = .decimal
		formatter.groupingSeparator = " "

		return formatter.string(from: NSNumber(value: self)) ?? ""
	}
}
