//
//  StringExtension.swift
//  MoneyM
//
//  Created by Air on 07.11.2023.
//

import Foundation

extension String {
    var isNumber: Bool {
        let expression = "^[0-9]+$"
        return self.range(of: expression, options: .regularExpression) != nil
    }
}
