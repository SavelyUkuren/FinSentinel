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

protocol AddTransactionDisplayLogic: AnyObject {
	func displayCreatedTransaction(_ viewModel: AddTransactionModels.Create.ViewModel)
}

class AddTransactionViewController: TransactionViewerViewController {

	public var interactor: AddTransactionBusinessLogic?

	public var router: AddTransactionRouter?

	public weak var delegate: AddTransactionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
		configureConfirmButton()
    }

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		router = nil
		interactor = nil
		delegate = nil
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

		let transactionType: TransactionType = switch choiceButton.selectedButton {
		case .first:
			TransactionType.expense
		case .second:
			TransactionType.income
		}

		let request = AddTransactionModels.Create.Request(amount: amountTextField.text!,
														  date: datePickerView.date,
														  category: selectedCategory,
														  transactionType: transactionType,
														  note: noteTextField.text)
		interactor?.create(request)
	}

	override func selectCategoryButtonClicked(_ sender: Any) {
		router?.routeToSelectCategory()
	}

}

// MARK: - Add transaction display logic
extension AddTransactionViewController: AddTransactionDisplayLogic {
	func displayCreatedTransaction(_ viewModel: AddTransactionModels.Create.ViewModel) {
		if viewModel.hasError, let errorMessage = viewModel.errorMessage {
			showAlertMessage(title: NSLocalizedString("error.title", comment: ""), message: errorMessage)
		}

		if let transaction = viewModel.model {
			delegate?.transactionCreated(transaction)
			dismiss(animated: true)
		}
	}
}
