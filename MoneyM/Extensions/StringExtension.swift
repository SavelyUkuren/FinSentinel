//
//  StringExtension.swift
//  MoneyM
//
//  Created by Air on 07.11.2023.
//

import Foundation

extension String {
    var isNumber: Bool {
		let doubleCheck = "([0-9]+.[0-9]+)"
		let intCheck = "([0-9]+)"
		
        let expression = "^\(doubleCheck)|\(intCheck)$"
        return self.range(of: expression, options: .regularExpression) != nil
    }
	var replaceCommaToDot: String {
		return self.replacingOccurrences(of: ",", with: ".")
	}
}
