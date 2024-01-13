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
		model.userInterfaceStyle = loadAppTheme()
	}

	public func changeCurrency(_ newCurrency: CurrencyModel) {
		model.currency = newCurrency
		NotificationCenter.default.post(name: NotificationNames.Currency, object: newCurrency)
		defaults.set(newCurrency.id, forKey: UserDefaultKeys.currencyID)
	}

	public func changeAccentColor(_ newColor: UIColor) {
		model.accentColor = newColor
		NotificationCenter.default.post(name: NotificationNames.AccentColor, object: newColor)
	}

	public func changeAppTheme(_ newTheme: UIUserInterfaceStyle) {
		model.userInterfaceStyle = newTheme
		defaults.set(newTheme.rawValue, forKey: UserDefaultKeys.userInterfaceStyle)
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

	private func loadAppTheme() -> UIUserInterfaceStyle {
		let theme = defaults.integer(forKey: UserDefaultKeys.userInterfaceStyle)
		return UIUserInterfaceStyle(rawValue: theme) ?? .unspecified
	}

}
