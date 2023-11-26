//
//  CustomColorPicker.swift
//  MoneyM
//
//  Created by Air on 26.11.2023.
//

import SwiftUI

struct CustomColorPicker: View {
	@State var title: String
	@Binding var selection: Color
	@State var action: () -> (Void)
	
	
	var body: some View {
		
		if #available(iOS 17.0, *) {
			
			ColorPicker(title, selection: $selection)
				.onChange(of: selection) { oldValue, newValue in
					action()
				}
			
		} else {
			
			ColorPicker(title, selection: $selection)
				.onChange(of: title, perform: { value in
					action()
				})
			
		}
		
	}
	
}
//
//#Preview {
//	CustomColorPicker(title: "Test", selection: Binding<Color>)
//}
