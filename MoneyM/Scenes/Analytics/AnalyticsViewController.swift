//
//  AnalyticsViewController.swift
//  MoneyM
//
//  Created by savik on 05.01.2024.
//

import UIKit

protocol AnalyticsDisplayLogic {
	
}

class AnalyticsViewController: UIViewController {

	public var interactor: AnalyticsBusinessLogic?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
	
	private func setup() {
		let viewController = self
		let interactor = AnalyticsInteractor()
		let presenter = AnalyticsPresenter()
		
		viewController.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = viewController
	}

}

// MARK: - Analytics display logic
extension AnalyticsViewController: AnalyticsDisplayLogic {
	
}
