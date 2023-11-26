//
//  SettingsView.swift
//  MoneyM
//
//  Created by Air on 25.11.2023.
//

import SwiftUI

struct SettingsView: View {
	@State var accentColor: Color = Color(cgColor: Settings.shared.model.accentColor.cgColor)
	
	var body: some View {
		VStack {
			List {
				
				CustomColorPicker(title: "Accent color", selection: $accentColor) {
					Settings.shared.changeAccentColor(UIColor(accentColor))
				}.padding()
				
			}
			
		}
		.navigationTitle("Settings")
	}
}

#Preview {
	SettingsView()
}
