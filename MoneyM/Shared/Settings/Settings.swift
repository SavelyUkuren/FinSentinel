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
	
	private var defaults = UserDefaults.standard
	
	private init() {
		model.currency = loadCurrency()
		model.accentColor = loadAccentColor()
	}
	
	public func changeCurrency(_ newCurrency: CurrencyModel) {
		model.currency = newCurrency
		NotificationCenter.default.post(name: Notifications.Currency, object: newCurrency)
		defaults.set(newCurrency.id, forKey: UserDefaultKeys.currencyID)
	}
	
	public func changeAccentColor(_ newColor: UIColor) {
		model.accentColor = newColor
		NotificationCenter.default.post(name: Notifications.AccentColor, object: newColor)
	}
	
	private func loadCurrency() -> CurrencyModel {
		
		let currencyModel: CurrencyModel
		let currencyModelManager = CurrencyModelManager()
		
		let currencyID = defaults.integer(forKey: UserDefaultKeys.currencyID)
		
		currencyModel = currencyModelManager.getCurrencyBy(id: currencyID) ??
												currencyModelManager.defaultCurrency
		
		return currencyModel
	}
	
	private func loadAccentColor() -> UIColor {
		return .systemBlue
	}
	
}
