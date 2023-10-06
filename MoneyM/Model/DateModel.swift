//
//  DateModel.swift
//  MoneyM
//
//  Created by Air on 06.10.2023.
//

import Foundation

class DateModel {
    var month: Int!
    var year: Int!
    
}

class DateModelManager {
    
    private(set) var months: [String] = []
    private(set) var years: [Int] = []
    
    init() {
        configureMonths()
        configureYears()
    }
    
    private func configureMonths() {
        months.append("January")
        months.append("February")
        months.append("March")
        months.append("April")
        months.append("May")
        months.append("June")
        months.append("July")
        months.append("August")
        months.append("September")
        months.append("October")
        months.append("November")
        months.append("December")
    }
    
    private func configureYears() {
        let currentYear = Calendar.current.component(.year, from: Date())
        
        for i in 1970...currentYear {
            years.append(i)
        }
    }
}
