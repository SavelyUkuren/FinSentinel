//
//  SettingsModels.swift
//  MoneyM
//
//  Created by savik on 08.12.2023.
//

import Foundation
import UIKit

struct SettingsModels {

	struct ChangeCurrency {
		struct Request {
			var currency: CurrencyModel
		}
		struct Response {

		}
		struct ViewModel {

		}
	}

	struct ChangeAppTheme {
		struct Request {
			let theme: AppearanceModel.Theme
		}
		struct Response {
			let userInterfaceStyle: UIUserInterfaceStyle
		}
		struct ViewModel {
			let userInterfaceStyle: UIUserInterfaceStyle
		}
	}

}
