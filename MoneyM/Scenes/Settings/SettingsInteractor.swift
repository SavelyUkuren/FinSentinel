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
}

class SettingsInteractor: SettingsBusinessLogic {

	var presenter: SettingsPresentLogic?

	func fetchSettings(_ request: SettingsModels.FetchSettings.Request) {
		var dataArray: [SettingsModels.TableViewSectionModel] = []

		dataArray.append(configureCurrency())

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

}
