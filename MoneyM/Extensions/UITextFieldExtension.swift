//
//  UITextFieldExtension.swift
//  MoneyM
//
//  Created by savik on 08.12.2023.
//

import Foundation
import UIKit

extension UITextField {
	@IBInspectable var localizedText: String? {
		get {
			return placeholder
		} set {
			placeholder = NSLocalizedString(newValue!, comment: "")
		}
	}
}
