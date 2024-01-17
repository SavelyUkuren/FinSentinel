//
//  DateExtension.swift
//  MoneyM
//
//  Created by savik on 13.01.2024.
//

import Foundation

extension Date {
	func startAndEndOfMonth(month: Int, year: Int) -> (start: Date?, end: Date?) {
		var components = DateComponents()
		components.day = 1
		components.month = month
		components.year = year
		
		if let startDate = Calendar.current.date(from: components) {
			if let range = Calendar.current.range(of: .day, in: .month, for: startDate) {
				components.day = range.count + 1
			}
			
			if let endDate = Calendar.current.date(from: components) {
				return (startDate, endDate)
			}
		}
		
		return (nil, nil)
	}
	
	func startAndEndOfYear(year: Int) -> (start: Date?, end: Date?) {
		let calendar = Calendar.current
		guard let startDate = calendar.date(from: DateComponents(year: year, month: 1, day: 1)),
			  let endDate = calendar.date(from: DateComponents(year: year, month: 12, day: 31)) else 
		{
			return (nil, nil)
		}
		
		return (startDate, endDate)
	}
	
	var monthTitle: String {
		
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM"

		let title = formatter.string(from: self)
		
		return title
	}
	
}
