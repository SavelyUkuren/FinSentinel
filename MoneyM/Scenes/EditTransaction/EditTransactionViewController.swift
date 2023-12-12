//
//  EditTransactionViewController.swift
//  MoneyM
//
//  Created by savik on 12.12.2023.
//

import UIKit

protocol EditTransactionDelegate {
	func didEditTransaction(_ newTransaction: TransactionModel)
}

protocol EditTransactionDisplayLogic {
	func displayLoadTransaction(_ viewModel: EditTransactionModels.LoadTransaction.ViewModel)
	func displayEditTransaction(_ viewModel: EditTransactionModels.EditTransaction.ViewModel)
}

class EditTransactionViewController: UIViewController {

	@IBOutlet weak var amountTextField: UITextField!
	
	@IBOutlet weak var datePickerView: UIDatePicker!
	
	@IBOutlet weak var choiceButton: ButtonChoiceView!
	
	@IBOutlet weak var noteTextField: UITextField!
	
	@IBOutlet weak var selectCategoryButton: UIButton!
	
	var interactor: EditTransactionBusinessLogic?
	
	var router: EditTransactionRouter?
	
	var transaction: TransactionModel?
	
	var delegate: EditTransactionDelegate?
	
	private var selectedCategory: CategoryModel?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		setup()
		configureAmountTextField()
		configureNoteTextField()
		configureChoiceButton()
		configureFont()
		
		if let unwrapTransaction = transaction {
			let request = EditTransactionModels.LoadTransaction.Request(transaction: unwrapTransaction)
			interactor?.loadTransaction(request)
		}
		
    }
    
	private func setup() {
		let viewController = self
		let interactor = EditTransactionInteractor()
		let presenter = EditTransactionPresenter()
		let router = EditTransactionRouter()
		
		viewController.interactor = interactor
		viewController.router = router
		router.viewController = viewController
		interactor.presenter = presenter
		presenter.viewController = viewController
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
		choiceButton.setButtonTitle(NSLocalizedString("expense.title", comment: ""), button: .First)
		choiceButton.setButtonTitle(NSLocalizedString("income.title", comment: ""), button: .Second)
		choiceButton.delegate = self
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

	@IBAction func editButtonClicked(_ sender: Any) {
		
		let mode: TransactionModel.Mode = switch choiceButton.selectedButton {
		case .First:
			TransactionModel.Mode.Expense
		case .Second:
			TransactionModel.Mode.Income
		}
		
		let request = EditTransactionModels.EditTransaction.Request(amount: amountTextField.text!,
																	 date: datePickerView.date,
																	 category: selectedCategory,
																	 mode: mode, note: noteTextField.text)
		interactor?.editTransaction(request)
	}
	
	@IBAction func selectCategoryButtonClicked(_ sender: Any) {
		router?.routeToSelectCategory()
	}
	
	@IBAction func cancelButtonClicked(_ sender: Any) {
		dismiss(animated: true)
	}
	
}

// MARK: - EditTransaction display logic
extension EditTransactionViewController: EditTransactionDisplayLogic {
	func displayLoadTransaction(_ viewModel: EditTransactionModels.LoadTransaction.ViewModel) {
		amountTextField.text = viewModel.amount
		
		switch viewModel.mode {
			case .Expense:
				choiceButton.selectButton(.First)
			case .Income:
				choiceButton.selectButton(.Second)
		}
		
		selectedCategory = viewModel.category
		selectCategoryButton.setTitle(selectedCategory?.title, for: .normal)
		
		datePickerView.date = viewModel.date
		noteTextField.text = viewModel.note
		
	}
	
	func displayEditTransaction(_ viewModel: EditTransactionModels.EditTransaction.ViewModel) {
		let transactionModel = viewModel.transactionModel
		transactionModel.id = transaction!.id
		delegate?.didEditTransaction(transactionModel)
		dismiss(animated: true)
	}
}

// MARK: Select category delegate
extension EditTransactionViewController: SelectCategoryViewControllerDelegate {
	func selectButtonClicked(category: CategoryModel?) {
		selectedCategory = category
		selectCategoryButton.setTitle(category?.title, for: .normal)
	}
}

// MARK: Button choice delegate
extension EditTransactionViewController: ButtonChoiceDelegate {
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
