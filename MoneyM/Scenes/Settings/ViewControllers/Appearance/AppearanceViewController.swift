//
//  AppearanceViewController.swift
//  MoneyM
//
//  Created by savik on 16.12.2023.

import UIKit

protocol AppearanceDelegate {
	func themeDidChange(_ theme: AppearanceModel.Theme)
}

class AppearanceViewController: UITableViewController {
	
	var delegate: AppearanceDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
}

// MARK: - TableView delegate
extension AppearanceViewController {
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		let theme: UIUserInterfaceStyle = Settings.shared.model.userInterfaceStyle
		
		if theme.rawValue == indexPath.row {
			cell.accessoryType = .checkmark
		}
		
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.section {
			case AppearanceModel.Sections.theme.rawValue:
				
				var theme: AppearanceModel.Theme = .system
				if indexPath.row == 0 {
					theme = .system
				} else if indexPath.row == 1 {
					theme = .light
				} else if indexPath.row == 2 {
					theme = .dark
				}
				
				tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
				delegate?.themeDidChange(theme)
				
				
			default:
				break
		}
	}
	
	override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		switch indexPath.section {
			case AppearanceModel.Sections.theme.rawValue:
				tableView.cellForRow(at: indexPath)?.accessoryType = .none
			default:
				break
		}
	}
	
}
