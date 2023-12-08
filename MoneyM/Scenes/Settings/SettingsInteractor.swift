//
//  SettingsInteractor.swift
//  MoneyM
//
//  Created by savik on 08.12.2023.
//

import Foundation

protocol SettingsBusinessLogic {
	func fetchSettings(_ request: SettingsModels.FetchSettings.Request)
}

class SettingsInteractor: SettingsBusinessLogic {
	
	var presenter: SettingsPresentLogic?
	
	func fetchSettings(_ request: SettingsModels.FetchSettings.Request) {
		var dataArray: [SettingsModels.TableViewSectionModel] = []
		
		let dataCells = [SettingsModels.TableViewCellModel(title: "Currency",
														   storyboardID: "Currency")]
		
		let dataSection = SettingsModels.TableViewSectionModel(section: "Data",
															   cells: dataCells)
		
		dataArray.append(dataSection)
		let response = SettingsModels.FetchSettings.Response(data: dataArray)
		presenter?.presentSettings(response)
	}
}
