//
//  SettingsInteractor.swift
//  MoneyM
//
//  Created by savik on 08.12.2023.
//

import Foundation
import UIKit

protocol SettingsBusinessLogic {
	func changeCurrency(_ request: SettingsModels.ChangeCurrency.Request)
	func changeAppTheme(_ request: SettingsModels.ChangeAppTheme.Request)
}

class SettingsInteractor: SettingsBusinessLogic {

	public var presenter: SettingsPresentLogic?

	func changeCurrency(_ request: SettingsModels.ChangeCurrency.Request) {
		Settings.shared.changeCurrency(request.currency)

		let response = SettingsModels.ChangeCurrency.Response()
		presenter?.presentCurrencyChange(response)
	}

	func changeAppTheme(_ request: SettingsModels.ChangeAppTheme.Request) {
		let userInterfaceStyle: UIUserInterfaceStyle
		switch request.theme {
		case .system:
			userInterfaceStyle = .unspecified
		case .light:
			userInterfaceStyle = .light
		case .dark:
			userInterfaceStyle = .dark
		}

		Settings.shared.changeAppTheme(userInterfaceStyle)

		let response = SettingsModels.ChangeAppTheme.Response(userInterfaceStyle: userInterfaceStyle)
		presenter?.presentAppTheme(response)
	}

}
