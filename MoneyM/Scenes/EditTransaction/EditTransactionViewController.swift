//
//  EditTransactionViewController.swift
//  MoneyM
//
//  Created by savik on 12.12.2023.
//

import UIKit

protocol EditTransactionDelegate: AnyObject {
	func didEditTransaction(_ newTransaction: TransactionModel)
}

protocol EditTransactionDisplayLogic: AnyObject {
	func displayLoadTransaction(_ viewModel: EditTransactionModels.LoadTransaction.ViewModel)
	func displayEditTransaction(_ viewModel: EditTransactionModels.EditTransaction.ViewModel)
}

class EditTransactionViewController: TransactionViewerViewController {

	var interactor: EditTransactionBusinessLogic?

	var router: EditTransactionRouter?

	var transaction: TransactionModel?

	var delegate: EditTransactionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

		setup()
		configureConfirmButton()

		if let unwrapTransaction = transaction {
			let request = EditTransactionModels.LoadTransaction.Request(transaction: unwrapTransaction)
			interactor?.loadTransaction(request)
		}

    }
	
	private func configureConfirmButton() {
		confirmButton.setTitle(NSLocalizedString("edit.title", comment: ""), for: .normal)
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
	
	override func confirmButtonClicked(_ sender: Any) {

		let mode: TransactionModel.Mode = switch choiceButton.selectedButton {
		case .first:
			TransactionModel.Mode.expense
		case .second:
			TransactionModel.Mode.income
		}

		let request = EditTransactionModels.EditTransaction.Request(amount: amountTextField.text!,
																	 date: datePickerView.date,
																	 category: selectedCategory,
																	 mode: mode, note: noteTextField.text)
		interactor?.editTransaction(request)
	}

	override func selectCategoryButtonClicked(_ sender: Any) {
		router?.routeToSelectCategory()
	}

}

// MARK: - EditTransaction display logic
extension EditTransactionViewController: EditTransactionDisplayLogic {
	func displayLoadTransaction(_ viewModel: EditTransactionModels.LoadTransaction.ViewModel) {
		amountTextField.text = viewModel.amount

		switch viewModel.mode {
		case .expense:
			choiceButton.selectButton(.first)
		case .income:
			choiceButton.selectButton(.second)
		}

		selectedCategory = viewModel.category
		selectCategoryButton.setTitle(selectedCategory?.title, for: .normal)

		datePickerView.date = viewModel.date
		noteTextField.text = viewModel.note

	}

	func displayEditTransaction(_ viewModel: EditTransactionModels.EditTransaction.ViewModel) {
		if viewModel.hasError, let errorMessage = viewModel.errorMessage {
			showAlertMessage(title: NSLocalizedString("error.title", comment: ""), message: errorMessage)
		}

		if let editedTransaction = viewModel.transactionModel,
		   let inputTransaction = self.transaction {
			let transactionCopy = editedTransaction
			transactionCopy.id = inputTransaction.id
			delegate?.didEditTransaction(transactionCopy)
			dismiss(animated: true)
		}

	}
}
