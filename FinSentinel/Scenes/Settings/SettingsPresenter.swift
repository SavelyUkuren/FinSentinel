//
//  SettingsPresenter.swift
//  MoneyM
//
//  Created by savik on 08.12.2023.
//

import Foundation

protocol SettingsPresentLogic {
	func presentCurrencyChange(_ response: SettingsModels.ChangeCurrency.Response)
	func presentAppTheme(_ response: SettingsModels.ChangeAppTheme.Response)
	func presentSourceCodeLink(_ response: SettingsModels.OpenSourceCodeLink.Response)
	func presentTelegramLink(_ response: SettingsModels.OpenTelegramLink.Response)
}

class SettingsPresenter: SettingsPresentLogic {

	public var viewController: SettingsDisplayLogic?

	func presentCurrencyChange(_ response: SettingsModels.ChangeCurrency.Response) {

		let viewModel = SettingsModels.ChangeCurrency.ViewModel()
		viewController?.displayCurrencyChange(viewModel)
	}

	func presentAppTheme(_ response: SettingsModels.ChangeAppTheme.Response) {
		let viewModel = SettingsModels.ChangeAppTheme.ViewModel(userInterfaceStyle: response.userInterfaceStyle)
		viewController?.displayAppTheme(viewModel)
	}
	
	func presentSourceCodeLink(_ response: SettingsModels.OpenSourceCodeLink.Response) {
		let viewModel = SettingsModels.OpenSourceCodeLink.ViewModel(url: response.url)
		viewController?.displaySourceCode(viewModel)
	}

	func presentTelegramLink(_ response: SettingsModels.OpenTelegramLink.Response) {
		let viewModel = SettingsModels.OpenSourceCodeLink.ViewModel(url: response.url)
		viewController?.displaySourceCode(viewModel)
	}
}
