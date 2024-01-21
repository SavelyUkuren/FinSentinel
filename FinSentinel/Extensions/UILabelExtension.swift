//
//  UILabelExtension.swift
//  MoneyM
//
//  Created by savik on 08.12.2023.
//
// https://stackoverflow.com/a/53479971

import Foundation
import UIKit

extension UILabel {
	@IBInspectable var localizedText: String? {
		get {
			return text
		} set {
			text = NSLocalizedString(newValue!, comment: "")
		}
	}
}
