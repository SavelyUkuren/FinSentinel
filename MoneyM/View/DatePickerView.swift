//
//  DatePickerView.swift
//  MoneyM
//
//  Created by Air on 06.09.2023.
//

import UIKit

protocol DatePickerViewDelegate {
    func chooseButtonClicked(dateModel: DateModel)
}

class DatePickerView: UIView {
    
    enum PickerComponent: Int {
        case Month = 0, Year
    }
    
    public var delegate: DatePickerViewDelegate?
    
    private var dateModelManager: DateModelManager!
    
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
        
        dateModelManager = DateModelManager()
        
        backgroundColor = .white
        
        configurePickerView()
        configureChooseButton()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setDatePickerBy(dateModel: DateModel) {
        pickerView.selectRow(dateModel.month - 1, inComponent: 0, animated: false)
        
        let yearIndex = dateModelManager.years.firstIndex { dateModel.year == $0 } ?? 0
        pickerView.selectRow(yearIndex, inComponent: 1, animated: false)
    }
    
    @objc
    private func chooseButtonClicked() {
        
        let monthSelectedIndex = pickerView.selectedRow(inComponent: 0)
        let yearSelectedIndex = pickerView.selectedRow(inComponent: 1)
        
        let dateModel = DateModel()
        dateModel.month = monthSelectedIndex + 1
        dateModel.year = dateModelManager.years[yearSelectedIndex]
        
        delegate?.chooseButtonClicked(dateModel: dateModel)
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

}

extension DatePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == PickerComponent.Month.rawValue {
            return dateModelManager.months.count
        }
        if component == PickerComponent.Year.rawValue {
            return dateModelManager.years.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == PickerComponent.Month.rawValue {
            return dateModelManager.months[row]
        }
        if component == PickerComponent.Year.rawValue {
            return "\(dateModelManager.years[row])"
        }
        return ""
    }
    
}
