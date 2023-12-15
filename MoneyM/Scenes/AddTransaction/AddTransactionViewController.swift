//
//  AddTransactionViewController.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//

import UIKit

protocol AddTransactionDelegate {
	func transactionCreated(_ transaction: TransactionModel)
}

protocol AddTransactionDisplayLogic {
	func displayCreatedTransaction(_ viewModel: AddTransactionModels.CreateTransaction.ViewModel)
}

class AddTransactionViewController: UIViewController {
	
	@IBOutlet weak var amountTextField: UITextField!
	
	@IBOutlet weak var datePickerView: UIDatePicker!
	
	@IBOutlet weak var choiceButton: ButtonChoiceView!
	
	@IBOutlet weak var noteTextField: UITextField!
	
	@IBOutlet weak var selectCategoryButton: UIButton!
	
	var interactor: AddTransactionBusinessLogic?
	
	var router: AddTransactionRouter?
	
	var delegate: AddTransactionDelegate?
	
	private var selectedCategory: CategoryModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
		configureAmountTextField()
		configureNoteTextField()
		configureChoiceButton()
		configureFont()
		
		//amountTextField.text = String(randomAmount())
    }
	
	override func viewDidAppear(_ animated: Bool) {
		amountTextField.becomeFirstResponder()
	}
    
	private func setup() {
		let viewController = self
		let interactor = AddTransactionInteractor()
		let presenter = AddTransactionPresenter()
		let router = AddTransactionRouter()
		
		viewController.interactor = interactor
		viewController.router = router
		router.viewController = viewController
		interactor.presenter = presenter
		presenter.viewController = viewController
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
		choiceButton.setButtonTitle(NSLocalizedString("expense.title", comment: ""), button: .First)
		choiceButton.setButtonTitle(NSLocalizedString("income.title", comment: ""), button: .Second)
		choiceButton.delegate = self
	}
	
	private func randomAmount() -> Int {
		return Int.random(in: 0...1000)
	}
	
	private func configureFont() {
		let font = CustomFonts()
		
		let amountTextFieldPointSize: CGFloat = amountTextField.font!.pointSize
		amountTextField.font = font.RoundedFont(amountTextFieldPointSize, .bold)
		
		let noteTextFieldPointSize: CGFloat = noteTextField.font!.pointSize
		noteTextField.font = font.RoundedFont(noteTextFieldPointSize, .semibold)
		
		choiceButton.setButtonFont(font.RoundedFont(18, .medium))
		
		selectCategoryButton.titleLabel?.font = font.RoundedFont(18, .regular)
	}
	
	private func resetCategory() {
		selectedCategory = CategoriesManager.shared.defaultCategory
		selectCategoryButton.setTitle(NSLocalizedString("select_category.title", comment: ""), for: .normal)
	}
	
	private func showAlertMessage(title: String, message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let alertAction = UIAlertAction(title: NSLocalizedString("ok.title", comment: ""), style: .default)
		alertController.addAction(alertAction)
		
		present(alertController, animated: true)
	}

	@IBAction func createButtonClicked(_ sender: Any) {
		
		let mode: TransactionModel.Mode = switch choiceButton.selectedButton {
		case .First:
			TransactionModel.Mode.Expense
		case .Second:
			TransactionModel.Mode.Income
		}
		
		let request = AddTransactionModels.CreateTransaction.Request(amount: amountTextField.text!,
																	 date: datePickerView.date,
																	 category: selectedCategory,
																	 mode: mode, note: noteTextField.text)
		interactor?.createTransaction(request)
	}
	
	@IBAction func selectCategoryButtonClicked(_ sender: Any) {
		router?.routeToSelectCategory()
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

// MARK: - Add transaction display logic
extension AddTransactionViewController: AddTransactionDisplayLogic {
	func displayCreatedTransaction(_ viewModel: AddTransactionModels.CreateTransaction.ViewModel) {
		if viewModel.hasError, let errorMessage = viewModel.errorMessage {
			showAlertMessage(title: NSLocalizedString("error.title", comment: ""), message: errorMessage)
		}
		
		if let transaction = viewModel.transactionModel {
			delegate?.transactionCreated(transaction)
			dismiss(animated: true)
		}
	}
}

// MARK: Select category delegate
extension AddTransactionViewController: SelectCategoryViewControllerDelegate {
	func selectButtonClicked(category: CategoryModel?) {
		selectedCategory = category
		selectCategoryButton.setTitle(category?.title, for: .normal)
	}
}

// MARK: Button choice delegate
extension AddTransactionViewController: ButtonChoiceDelegate {
	func buttonClicked(button: ButtonChoiceView.Buttons) {
		switch button {
		case .First: // Expense button
			amountTextField.textColor = .systemRed
		case .Second: // Income button
			amountTextField.textColor = .systemGreen
		}
		resetCategory()
	}
}
