//
//  HomeViewController.swift
//  MoneyM
//
//  Created by Air on 30.11.2023.
//

import UIKit

protocol HomeDisplayLogic {
	
}

class HomeViewController: UIViewController {
	
	@IBOutlet weak var balanceAmountLabel: UILabel!
	
	@IBOutlet weak var expenseAmountLabel: UILabel!
	
	@IBOutlet weak var incomeAmountLabel: UILabel!
	
	@IBOutlet weak var transactionsTableView: UITableView!
	
	@IBOutlet weak var addTransactionButton: UIButton!
	
	var interactor: HomeBusinessLogic?

    override func viewDidLoad() {
        super.viewDidLoad()

		setup()
		addTransactionButton.setTitle("Ass", for: .normal)
    }
    
	private func setup() {
		let viewController = self
		let interactor = HomeInteractor()
		let presenter = HomePresenter()
		
		viewController.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = viewController
	}
	
	// MARK: Actions
	@IBAction func addTransactionButtonClicked(_ sender: Any) {
		
	}
	
}

// MARK: - Display logic
extension HomeViewController: HomeDisplayLogic {
	
	
	
}
