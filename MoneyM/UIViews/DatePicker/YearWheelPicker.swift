//
//  YearWheelPicker.swift
//  MoneyM
//
//  Created by savik on 05.01.2024.
//

import UIKit

class YearWheelPicker: UIPickerView {
	
	private var years: [Int] = []
	
	public var selectedYear: Int = 0

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		delegate = self
		dataSource = self
		
		let currentYear = Calendar.current.component(.year, from: Date())
		
		selectedYear = currentYear
		
		for year in 1970...currentYear {
			years.append(year)
		}
		
		selectRow(years.count - 1, inComponent: 0, animated: false)
		
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
}

extension YearWheelPicker: UIPickerViewDelegate, UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		years.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		String(years[row])
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectedYear = years[row]
	}
}
