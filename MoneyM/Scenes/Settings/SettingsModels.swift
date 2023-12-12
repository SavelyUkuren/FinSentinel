//
//  SettingsModels.swift
//  MoneyM
//
//  Created by savik on 08.12.2023.
//

import Foundation
import UIKit

struct SettingsModels {
	
	struct TableViewCellModel {
		var title: String
		var storyboardID: String
	}
	
	struct TableViewSectionModel {
		var section: String
		var cells: [TableViewCellModel]
	}
	
	struct FetchSettings {
		struct Request {
			
		}
		struct Response {
			var data: [TableViewSectionModel]
		}
		struct ViewModel {
			var data: [TableViewSectionModel]
		}
	}
	
	struct ChangeCurrency {
		struct Request {
			var currency: CurrencyModel
		}
		struct Response {
			
		}
		struct ViewModel {
			
		}
	}
	
}
