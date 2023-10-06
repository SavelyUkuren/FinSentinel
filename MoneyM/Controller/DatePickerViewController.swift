//
//  DatePickerViewController.swift
//  MoneyM
//
//  Created by Air on 06.09.2023.
//

import UIKit

protocol DatePickerViewControllerDelegate {
    func chooseButtonClicked(dateModel: DateModel)
}

class DatePickerViewController: UIViewController {
    
    public var dateModel: DateModel?
    
    public var delegate: DatePickerViewControllerDelegate?

    private var datePicker: DatePickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = DatePickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.delegate = self
        
        if let dateModel = dateModel {
            datePicker.setDatePickerBy(dateModel: dateModel)
        }
        
        view = datePicker
    }
    
}

extension DatePickerViewController: DatePickerViewDelegate {
    func chooseButtonClicked(dateModel: DateModel) {
        delegate?.chooseButtonClicked(dateModel: dateModel)
        dismiss(animated: true)
    }
    
}
