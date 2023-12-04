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
		
		//amountTextField.text = String(randomAmount())
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
	}
	
	private func configureNoteTextField() {
		noteTextField.layer.cornerRadius = 12
		noteTextField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0)
	}
	
	private func configureChoiceButton() {
		choiceButton.setButtonTitle("Expense", button: .First)
		choiceButton.setButtonTitle("Income", button: .Second)
	}
	
	private func randomAmount() -> Int {
		return Int.random(in: 0...1000)
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
	
}

// MARK: - Add transaction display logic
extension AddTransactionViewController: AddTransactionDisplayLogic {
	func displayCreatedTransaction(_ viewModel: AddTransactionModels.CreateTransaction.ViewModel) {
		delegate?.transactionCreated(viewModel.transactionModel)
		dismiss(animated: true)
	}
}

// MARK: Select category delegate
extension AddTransactionViewController: SelectCategoryViewControllerDelegate {
	func selectButtonClicked(category: CategoryModel?) {
		selectedCategory = category
	}
}
