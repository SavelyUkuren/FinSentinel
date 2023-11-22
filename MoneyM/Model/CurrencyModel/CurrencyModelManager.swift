//
//  CurrencyModelManager.swift
//  MoneyM
//
//  Created by Air on 01.11.2023.
//

import Foundation

protocol CurrencyModelManagerDelegate {
    func currencyDidUpdate()
}

class CurrencyModelManager {
	
	struct CurrencyData: Codable {
		var currencies: [CurrencyModel]
	}
    
	private var currencies: [Int: CurrencyModel] = [:]
    
    init() {
		loadCurrencies()
    }
	
	public func getCurrencyBy(id: Int) -> CurrencyModel? {
		return currencies[id]
	}
	
	private func loadCurrencies() {
		let jsonURL = Bundle.main.url(forResource: "Currencies", withExtension: "json")!
		
		if let data = loadFromJSON(jsonURL) {
			for currency in data.currencies {
				currencies[currency.id] = currency
			}
		}
	}
    
	private func loadFromJSON(_ url: URL) -> CurrencyData? {
		var currencyData = CurrencyData(currencies: [])
		
		do {
			let data = try Data(contentsOf: url)
			currencyData = try JSONDecoder().decode(CurrencyData.self, from: data)
			
		} catch {
			fatalError("\(error)")
		}
		
		return currencyData
	}
    
}
