//
//  DatePickerViewController.swift
//  MoneyM
//
//  Created by Air on 06.09.2023.
//

import UIKit

protocol DatePickerViewControllerDelegate {
    func chooseButtonClicked()
}

class DatePickerViewController: UIViewController {
    
    public var delegate: DatePickerViewControllerDelegate?

    private var datePicker: DatePickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = DatePickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.delegate = self
        
        view = datePicker
    }
    
}

extension DatePickerViewController: DatePickerViewDelegate {
    
    func chooseButtonClicked() {
        delegate?.chooseButtonClicked()
        dismiss(animated: true)
    }
    
}
