//
//  TransactionViewerViewController.swift
//  MoneyM
//
//  Created by savik on 19.12.2023.
//

import UIKit

class TransactionViewerViewController: UIViewController {
	
	@IBOutlet weak var amountTextField: UITextField!

	@IBOutlet weak var datePickerView: UIDatePicker!

	@IBOutlet weak var choiceButton: ButtonChoiceView!

	@IBOutlet weak var noteTextField: UITextField!

	@IBOutlet weak var selectCategoryButton: UIButton!
	
	@IBOutlet weak var confirmButton: UIButton!
	
	public var selectedCategory: CategoryModel?

    override func viewDidLoad() {
        super.viewDidLoad()

		configureAmountTextField()
		configureNoteTextField()
		configureChoiceButton()
		configureFont()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		amountTextField.becomeFirstResponder()
	}
	
	private func configureAmountTextField() {
		amountTextField.layer.cornerRadius = 12
		amountTextField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0)
		amountTextField.textColor = .systemRed
	}

	private func configureNoteTextField() {
		noteTextField.layer.cornerRadius = 12
		noteTextField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0)
	}

	private func configureChoiceButton() {
		choiceButton.setButtonTitle(NSLocalizedString("expense.title", comment: ""), button: .first)
		choiceButton.setButtonTitle(NSLocalizedString("income.title", comment: ""), button: .second)
		choiceButton.delegate = self
	}
	
	private func configureFont() {
		let font = CustomFonts()

		let amountTextFieldPointSize: CGFloat = amountTextField.font!.pointSize
		amountTextField.font = font.roundedFont(amountTextFieldPointSize, .bold)

		let noteTextFieldPointSize: CGFloat = noteTextField.font!.pointSize
		noteTextField.font = font.roundedFont(noteTextFieldPointSize, .semibold)

		choiceButton.setButtonFont(font.roundedFont(18, .medium))

		selectCategoryButton.titleLabel?.font = font.roundedFont(18, .regular)
	}

	private func resetCategory() {
		selectedCategory = CategoriesManager.shared.defaultCategory
		selectCategoryButton.setTitle(NSLocalizedString("select_category.title", comment: ""), for: .normal)
	}

	public func showAlertMessage(title: String, message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let alertAction = UIAlertAction(title: NSLocalizedString("ok.title", comment: ""), style: .default)
		alertController.addAction(alertAction)

		present(alertController, animated: true)
	}
	
	// MARK: Actions
	@IBAction func confirmButtonClicked(_ sender: Any) {
		
	}

	@IBAction func selectCategoryButtonClicked(_ sender: Any) {
		
	}

	@IBAction func cancelButtonClicked(_ sender: Any) {
		dismiss(animated: true)
	}

	@IBAction func amountTextFieldChanged(_ sender: Any) {
		if let text = amountTextField.text {
			// Remove spaces from current string "1 000" -> "1000"
			let numberStr = text.components(separatedBy: .whitespaces).joined()
			let number = Int(numberStr)
			let separatorNumber = number?.thousandSeparator
			amountTextField.text = separatorNumber
		}
	}
	
}

// MARK: Select category delegate
extension TransactionViewerViewController: SelectCategoryViewControllerDelegate {
	func selectButtonClicked(category: CategoryModel?) {
		selectedCategory = category
		selectCategoryButton.setTitle(category?.title, for: .normal)
	}
}

// MARK: Button choice delegate
extension TransactionViewerViewController: ButtonChoiceDelegate {
	func buttonClicked(button: ButtonChoiceView.Buttons) {
		switch button {
		case .first: // Expense button
			amountTextField.textColor = .systemRed
		case .second: // Income button
			amountTextField.textColor = .systemGreen
		}
		resetCategory()
	}
}
