//
//  Settings.swift
//  MoneyM
//
//  Created by Air on 22.11.2023.
//

import Foundation
import UIKit

class Settings {
	public static let shared = Settings()
	
	public var model = SettingsModel()
	
	public let notificationCurrencyChange = NSNotification.Name("CurrencyChanged")
	
	public let notificationAccentColorChange = NSNotification.Name("AccentColorChanged")
	
	private init() {
		model.currency = loadCurrency()
		model.accentColor = loadAccentColor()
	}
	
	public func changeCurrency(_ newCurrency: CurrencyModel) {
		model.currency = newCurrency
		NotificationCenter.default.post(name: notificationCurrencyChange, object: newCurrency)
	}
	
	public func changeAccentColor(_ newColor: UIColor) {
		model.accentColor = newColor
		NotificationCenter.default.post(name: notificationAccentColorChange, object: newColor)
	}
	
	private func loadCurrency() -> CurrencyModel {
		let currencyModelManager = CurrencyModelManager()
		let currencyModel = currencyModelManager.getCurrencyBy(id: 1)
		
		return currencyModel!
	}
	
	private func loadAccentColor() -> UIColor {
		return UIStyle.AccentColor
	}
	
}
