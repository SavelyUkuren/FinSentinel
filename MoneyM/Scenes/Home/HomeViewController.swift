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
	
	var interactor: HomeBusinessLogic?

    override func viewDidLoad() {
        super.viewDidLoad()

		setup()
    }
    
	private func setup() {
		let viewController = self
		let interactor = HomeInteractor()
		let presenter = HomePresenter()
		
		viewController.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = viewController
	}
	
}

// MARK: - Display logic
extension HomeViewController: HomeDisplayLogic {
	
	
	
}
