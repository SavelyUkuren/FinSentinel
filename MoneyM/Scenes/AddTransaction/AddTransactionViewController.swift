//
//  AddTransactionViewController.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//

import UIKit

protocol AddTransactionDelegate: AnyObject {
	func transactionCreated(_ transaction: TransactionModel)
}

protocol AddTransactionDisplayLogic {
	func displayCreatedTransaction(_ viewModel: AddTransactionModels.CreateTransaction.ViewModel)
}

class AddTransactionViewController: TransactionViewerViewController {

	var interactor: AddTransactionBusinessLogic?

	var router: AddTransactionRouter?

	var delegate: AddTransactionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
		configureConfirmButton()
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
	
	private func configureConfirmButton() {
		confirmButton.setTitle(NSLocalizedString("create.title", comment: ""), for: .normal)
	}
	
	override func confirmButtonClicked(_ sender: Any) {

		let mode: TransactionModel.Mode = switch choiceButton.selectedButton {
		case .first:
			TransactionModel.Mode.expense
		case .second:
			TransactionModel.Mode.income
		}

		let request = AddTransactionModels.CreateTransaction.Request(amount: amountTextField.text!,
																	 date: datePickerView.date,
																	 category: selectedCategory,
																	 mode: mode, note: noteTextField.text)
		interactor?.createTransaction(request)
	}
	
	override func selectCategoryButtonClicked(_ sender: Any) {
		router?.routeToSelectCategory()
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
