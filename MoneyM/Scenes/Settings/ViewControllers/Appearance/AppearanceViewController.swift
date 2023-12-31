//
//  AppearanceViewController.swift
//  MoneyM
//
//  Created by savik on 16.12.2023.

import UIKit

protocol AppearanceDelegate: AnyObject {
	func themeDidChange(_ theme: AppearanceModel.Theme)
}

class AppearanceViewController: UITableViewController {

	enum Sections: Int {
		case theme
	}

	enum ThemeCell: Int {
		case system, light, dark
	}

	public weak var delegate: AppearanceDelegate?

	override func viewWillAppear(_ animated: Bool) {
		let indexPath = lastSelectedTheme()
		tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
		tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
	}

	private func lastSelectedTheme() -> IndexPath {
		let style = Settings.shared.model.userInterfaceStyle ?? .unspecified
		var indexPath = IndexPath(row: 0, section: 0)

		switch style {
		case .unspecified:
			indexPath.row = ThemeCell.system.rawValue
		case .light:
			indexPath.row = ThemeCell.light.rawValue
		case .dark:
			indexPath.row = ThemeCell.dark.rawValue
		@unknown default:
			break
		}

		return indexPath
	}

}

// MARK: - TableView delegate
extension AppearanceViewController {

	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

		cell.selectionStyle = .none

	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.section {
		case AppearanceModel.Sections.theme.rawValue:

			var theme: AppearanceModel.Theme = .system
			if indexPath.row == ThemeCell.system.rawValue {
				theme = .system
			} else if indexPath.row == ThemeCell.light.rawValue {
				theme = .light
			} else if indexPath.row == ThemeCell.dark.rawValue {
				theme = .dark
			}

			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
			delegate?.themeDidChange(theme)

		default:
			break
		}
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		var title: String?

		if section == Sections.theme.rawValue {
			title = NSLocalizedString("theme.title", comment: "")
		}

		return title
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
