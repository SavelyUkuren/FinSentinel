//
//  Settings.swift
//  MoneyM
//
//  Created by Air on 22.11.2023.
//

import Foundation

class Settings {
	public static let shared = Settings()
	
	public var model = SettingsModel()
	
	public let notificationCurrencyChange = NSNotification.Name("CurrencyChanged")
	
	private init() {
		model.currency = loadCurrency()
	}
	
	public func changeCurrency(_ newCurrency: CurrencyModel) {
		model.currency = newCurrency
		NotificationCenter.default.post(name: notificationCurrencyChange, object: newCurrency)
	}
	
	private func loadCurrency() -> CurrencyModel {
		let currencyModelManager = CurrencyModelManager()
		let currencyModel = currencyModelManager.getCurrencyBy(id: 1)
		
		return currencyModel!
	}
	
}
