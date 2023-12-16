//
//  SettingsInteractor.swift
//  MoneyM
//
//  Created by savik on 08.12.2023.
//

import Foundation
import UIKit

protocol SettingsBusinessLogic {
	func fetchSettings(_ request: SettingsModels.FetchSettings.Request)
	func changeCurrency(_ request: SettingsModels.ChangeCurrency.Request)
	func changeAppTheme(_ request: SettingsModels.ChangeAppTheme.Request)
}

class SettingsInteractor: SettingsBusinessLogic {

	var presenter: SettingsPresentLogic?

	func fetchSettings(_ request: SettingsModels.FetchSettings.Request) {
		var dataArray: [SettingsModels.TableViewSectionModel] = []

		dataArray.append(configureCurrency())
		dataArray.append(configureAppearance())

		let response = SettingsModels.FetchSettings.Response(data: dataArray)
		presenter?.presentSettings(response)
	}

	func changeCurrency(_ request: SettingsModels.ChangeCurrency.Request) {
		Settings.shared.changeCurrency(request.currency)

		let response = SettingsModels.ChangeCurrency.Response()
		presenter?.presentCurrencyChange(response)
	}

	private func configureCurrency() -> SettingsModels.TableViewSectionModel {
		let dataCells = [SettingsModels.TableViewCellModel(title: NSLocalizedString("currency.title", comment: ""),
														   icon: UIImage(systemName: "dollarsign.circle"),
														   iconBackgroundColor: .systemPink,
														   storyboardID: "Currency")]

		let dataSection = SettingsModels.TableViewSectionModel(section: NSLocalizedString("data.title", comment: ""),
															   cells: dataCells)
		return dataSection
	}

	private func configureAppearance() -> SettingsModels.TableViewSectionModel {
		let dataCells = [SettingsModels.TableViewCellModel(title: "Appearance",
														   icon: nil,
														   iconBackgroundColor: .systemGray4,
														   storyboardID: "Appearance")]

		let dataSection = SettingsModels.TableViewSectionModel(section: "General",
															   cells: dataCells)
		return dataSection
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
