//
//  SettingsViewController.swift
//  MoneyM
//
//  Created by savik on 08.12.2023.
//

import UIKit

protocol SettingsDisplayLogic {
	
}

class SettingsViewController: UIViewController {

	@IBOutlet weak var settingsTableView: UITableView!
	
	var interactor: SettingsBusinessLogic?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		setup()
    }
	
	private func setup() {
		let viewController = self
		let router = SettingsRouter()
		let interactor = SettingsInteractor()
		let presenter = SettingsPresenter()
		
		viewController.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
	}

}

// MARK: - Display logic
extension SettingsViewController: SettingsDisplayLogic {
	
}
