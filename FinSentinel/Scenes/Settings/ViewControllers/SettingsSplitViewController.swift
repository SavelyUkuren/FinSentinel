//
//  SettingsSplitViewController.swift
//  MoneyM
//
//  Created by savik on 28.12.2023.
//

import UIKit

class SettingsSplitViewController: UISplitViewController {

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		if let settingsVC = viewControllers.first?.children.first as? SettingsMasterViewController {
			settingsVC.interactor = nil
		}

	}

}
