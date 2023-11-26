//
//  CurrencyListView.swift
//  MoneyM
//
//  Created by Air on 26.11.2023.
//

import SwiftUI

struct CurrencyListView: View {
	@Environment(\.dismiss) var dismiss
	
	let currencyModelManager = CurrencyModelManager()
	@State var selectedCurrency: CurrencyModel?
	
	var body: some View {
		VStack {
			if #available(iOS 17.0, *) {
				
				List(Array(currencyModelManager.currencies.values), id: \.self, selection: $selectedCurrency) { value in
					Text("\(value.symbol) \(value.title)")
				}.onChange(of: selectedCurrency) { oldValue, newValue in
					currencySelected(newValue)
				}
				
			} else {
				
				List(Array(currencyModelManager.currencies.values), id: \.self, selection: $selectedCurrency) { value in
					Text("\(value.symbol) \(value.title)")
				}.onChange(of: selectedCurrency, perform: { value in
					currencySelected(value)
				})
				
			}
		}.navigationTitle("Currency")
		
	}
	
	private func currencySelected(_ currencyModel: CurrencyModel?) {
		if let currency = currencyModel {
			Settings.shared.changeCurrency(currency)
			dismiss()
		}
	}
}

#Preview {
	CurrencyListView()
}
