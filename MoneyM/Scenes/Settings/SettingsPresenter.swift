//
//  SettingsPresenter.swift
//  MoneyM
//
//  Created by savik on 08.12.2023.
//

import Foundation

protocol SettingsPresentLogic {
	func presentSettings(_ response: SettingsModels.FetchSettings.Response)
	func presentCurrencyChange(_ response: SettingsModels.ChangeCurrency.Response)
	func presentAppTheme(_ response: SettingsModels.ChangeAppTheme.Response)
}

class SettingsPresenter: SettingsPresentLogic {

	var viewController: SettingsDisplayLogic?

	func presentSettings(_ response: SettingsModels.FetchSettings.Response) {
		let viewModel = SettingsModels.FetchSettings.ViewModel(data: response.data)
		viewController?.displaySettings(viewModel)
	}

	func presentCurrencyChange(_ response: SettingsModels.ChangeCurrency.Response) {

		let viewModel = SettingsModels.ChangeCurrency.ViewModel()
		viewController?.displayCurrencyChange(viewModel)
	}

	func presentAppTheme(_ response: SettingsModels.ChangeAppTheme.Response) {
		let viewModel = SettingsModels.ChangeAppTheme.ViewModel(userInterfaceStyle: response.userInterfaceStyle)
		viewController?.displayAppTheme(viewModel)
	}
	
}
