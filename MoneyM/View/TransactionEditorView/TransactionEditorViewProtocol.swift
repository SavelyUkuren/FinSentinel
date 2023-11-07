//
//  TransactionEditorViewProtocol.swift
//  MoneyM
//
//  Created by Air on 07.11.2023.
//

import UIKit

protocol TransactionEditorViewProtocol {
    var delegate: TransactionEditorViewDelegate? { get set }
    var selectedMode: TransactionModel.Mode { get set }
    var selectedCategory: CategoryModel { get set }
    
    var amountLabel: UILabel { get }
    var amountTextField: UITextField { get }
    var confirmButton: UIButton { get }
    var choiceModeButton: ButtonChoiceView { get }
    var selectCategoryButton: UIButton { get }
    var datePicker: UIDatePicker { get }
    
    func configrmButtonClicked()
    func selectCategoryButtonClicked()
    func configureAmountLabel()
    func configureAmountTextField()
    func configureAddTransactionButton()
    func configureChoiceModeButton()
    func configureSelectCategoryButton()
    func configureDatePicker()
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
}
