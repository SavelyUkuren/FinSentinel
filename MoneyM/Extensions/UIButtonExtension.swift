//
//  UIButton.swift
//  MoneyM
//
//  Created by savik on 08.12.2023.
//

import Foundation
import UIKit

extension UIButton {
	@IBInspectable var localizedText: String? {
		get {
			return titleLabel?.text
		} set {
			setTitle(NSLocalizedString(newValue!, comment: ""), for: .normal)
		}
	}
}
