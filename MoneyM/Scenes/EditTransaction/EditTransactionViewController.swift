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
	func displayTransaction(_ viewModel: EditTransactionModels.Load.ViewModel)
	func displayEditedTransaction(_ viewModel: EditTransactionModels.Edit.ViewModel)
}

class EditTransactionViewController: TransactionViewerViewController {

	public var interactor: EditTransactionBusinessLogic?

	public var router: EditTransactionRouter?

	public var transaction: TransactionModel?

	public var delegate: EditTransactionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

		setup()
		configureConfirmButton()

		if let unwrapTransaction = transaction {
			let request = EditTransactionModels.Load.Request(transaction: unwrapTransaction)
			interactor?.load(request)
		}

    }

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		interactor = nil
		router = nil
		delegate = nil
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

		let request = EditTransactionModels.Edit.Request(amount: amountTextField.text!,
																	 date: datePickerView.date,
																	 category: selectedCategory,
																	 mode: mode, note: noteTextField.text)
		interactor?.edit(request)
	}

	override func selectCategoryButtonClicked(_ sender: Any) {
		router?.routeToSelectCategory()
	}

}

// MARK: - EditTransaction display logic
extension EditTransactionViewController: EditTransactionDisplayLogic {
	func displayTransaction(_ viewModel: EditTransactionModels.Load.ViewModel) {
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

	func displayEditedTransaction(_ viewModel: EditTransactionModels.Edit.ViewModel) {
		if viewModel.hasError, let errorMessage = viewModel.errorMessage {
			showAlertMessage(title: NSLocalizedString("error.title", comment: ""), message: errorMessage)
		}

		if let editedTransaction = viewModel.model,
		   let inputTransaction = self.transaction {
			let transactionCopy = editedTransaction
			transactionCopy.id = inputTransaction.id
			delegate?.didEditTransaction(transactionCopy)
			dismiss(animated: true)
		}

	}
}
