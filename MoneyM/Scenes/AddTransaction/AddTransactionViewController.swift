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
	
	var interactor: AddTransactionBusinessLogic?
	
	var router: AddTransactionRouter?
	
	var delegate: AddTransactionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
		amountTextField.text = String(randomAmount())
    }
    
	private func setup() {
		let viewController = self
		let interactor = AddTransactionInteractor()
		let presenter = AddTransactionPresenter()
		let router = viewController.router
		
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
	}
	
	private func randomAmount() -> Int {
		return Int.random(in: 0...1000)
	}

	@IBAction func createButtonClicked(_ sender: Any) {
		let request = AddTransactionModels.CreateTransaction.Request(amount: amountTextField.text!,
																	 date: datePickerView.date)
		interactor?.createTransaction(request)
	}
}

// MARK: - Add transaction display logic
extension AddTransactionViewController: AddTransactionDisplayLogic {
	func displayCreatedTransaction(_ viewModel: AddTransactionModels.CreateTransaction.ViewModel) {
		delegate?.transactionCreated(viewModel.transactionModel)
		dismiss(animated: true)
	}
}
