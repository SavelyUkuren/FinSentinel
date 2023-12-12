//
//  UINavigationItem.swift
//  MoneyM
//
//  Created by savik on 08.12.2023.
//

import Foundation
import UIKit

extension UINavigationItem {
	@IBInspectable var localizedText: String? {
		get {
			return title
		} set {
			title = NSLocalizedString(newValue!, comment: "")
		}
	}
}
