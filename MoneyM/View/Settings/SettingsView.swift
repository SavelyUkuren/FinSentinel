//
//  SettingsView.swift
//  MoneyM
//
//  Created by Air on 25.11.2023.
//

import SwiftUI

struct SettingsView: View {
	@State var accentColor: Color = Color(cgColor: Settings.shared.model.accentColor.cgColor)
	@State var currencyLabel: String = Settings.shared.model.currency.symbol
	
	var body: some View {
		VStack {
			List {
				
				CustomColorPicker(title: "Accent color", selection: $accentColor) {
					Settings.shared.changeAccentColor(UIColor(accentColor))
				}.padding()
				
				NavigationLink("Currency \(currencyLabel)") {
					CurrencyListView()
				}
			}
		}
		.onAppear() {
			let model = Settings.shared.model.currency
			currencyLabel = currencyBeauty(currencyModel: model!)
		}
		.navigationTitle("Settings")
	}
	
	private func currencyBeauty(currencyModel: CurrencyModel) -> String {
		let title = currencyModel.title
		return "\(title)"
	}
}

#Preview {
	SettingsView()
}
