//
//  DatePickerView.swift
//  MoneyM
//
//  Created by Air on 06.09.2023.
//

import UIKit

protocol DatePickerViewDelegate {
    func chooseButtonClicked()
}

class DatePickerView: UIView {
    
    enum PickerComponent: Int {
        case Month = 0, Year
    }
    
    public var delegate: DatePickerViewDelegate?
    
    private var months: [String] = []
    private var years: [String] = []
    
    private let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private let chooseButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("Choose", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        configurePickerView()
        configureMonthYears()
        configureChooseButton()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc
    private func chooseButtonClicked() {
        delegate?.chooseButtonClicked()
    }
    
    private func configurePickerView() {
        addSubview(pickerView)
        
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            pickerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            pickerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            pickerView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.backgroundColor = .systemGray6
        
    }
    
    private func configureChooseButton() {
        addSubview(chooseButton)
        
        NSLayoutConstraint.activate([
            chooseButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            chooseButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            chooseButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            chooseButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        chooseButton.addTarget(self, action: #selector(chooseButtonClicked), for: .touchUpInside)
    }
    
    private func configureMonthYears() {
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
        
        for i in 1970...2023 {
            years.append("\(i)")
        }
    }

}

extension DatePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == PickerComponent.Month.rawValue {
            return months.count
        }
        if component == PickerComponent.Year.rawValue {
            return years.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == PickerComponent.Month.rawValue {
            return months[row]
        }
        if component == PickerComponent.Year.rawValue {
            return years[row]
        }
        return ""
    }
    
}
