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
    
    static let shared = CurrencyModelManager()
    
    public var delegate: CurrencyModelManagerDelegate?
    
    private var currencies: [Int: CurrencyModel] = [:]
    
    private(set) var selectedCurrency: CurrencyModel!
    
    private init() {
        currencies[0] = CurrencyModel(symbol: "$", title: "Dollar (USA)")
        currencies[1] = CurrencyModel(symbol: "₽", title: "Rouble (RUB)")
        
        selectedCurrency = currencies[0]
    }
    
    public func getCurrency(byID id: Int) -> CurrencyModel? {
        return currencies[id]
    }
    
}
