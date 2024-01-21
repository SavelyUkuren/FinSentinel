//
//  UITabBarExtension.swift
//  MoneyM
//
//  Created by savik on 03.01.2024.
//

import Foundation
import UIKit

extension UITabBarItem {
	@IBInspectable var localizedText: String? {
		get {
			return title
		} set {
			title = NSLocalizedString(newValue!, comment: "")
		}
	}
}
