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
	func openSourceCode(_ request: SettingsModels.OpenSourceCodeLink.Request)
	func openTelegram(_ request: SettingsModels.OpenTelegramLink.Request)
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
	
	func openSourceCode(_ request: SettingsModels.OpenSourceCodeLink.Request) {
		guard let url = URL(string: "https://github.com/SavelyUkuren/MoneyM") else { return }
		
		let response = SettingsModels.OpenSourceCodeLink.Response(url: url)
		presenter?.presentSourceCodeLink(response)
	}
	
	func openTelegram(_ request: SettingsModels.OpenTelegramLink.Request) {
		guard let url = URL(string: "https://t.me/FKN_sl4ve") else { return }
		
		let response = SettingsModels.OpenTelegramLink.Response(url: url)
		presenter?.presentTelegramLink(response)
	}

}
