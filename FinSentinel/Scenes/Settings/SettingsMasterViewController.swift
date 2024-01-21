//
//  SettingsMasterViewController.swift
//  MoneyM
//
//  Created by savik on 08.12.2023.
//

import UIKit

protocol SettingsDisplayLogic: AnyObject {
	func displayCurrencyChange(_ viewModel: SettingsModels.ChangeCurrency.ViewModel)
	func displayAppTheme(_ viewModel: SettingsModels.ChangeAppTheme.ViewModel)
	func displaySourceCode(_ viewModel: SettingsModels.OpenSourceCodeLink.ViewModel)
	func displayTelegram(_ viewModel: SettingsModels.OpenTelegramLink.ViewModel)
}

class SettingsMasterViewController: UITableViewController {

	enum Sections: Int {
		case data, general, feedback
	}
	
	enum Feedback: Int {
		case sourceCode, telegram
	}

	public var interactor: SettingsBusinessLogic?

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

	// MARK: Actions
	@IBAction func cancelButtonClicked(_ sender: Any) {
		dismiss(animated: true)
	}

	// MARK: - Table view data source
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if let currencyVC = segue.destination as? CurrencyViewController {
			currencyVC.delegate = self
		} else if let appearanceVC = segue.destination as? AppearanceViewController {
			appearanceVC.delegate = self
		}

	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		var title: String?

		switch section {
			case Sections.data.rawValue:
				title = NSLocalizedString("data.title", comment: "")
			case Sections.general.rawValue:
				title = NSLocalizedString("general.title", comment: "")
			case Sections.feedback.rawValue:
				title = NSLocalizedString("feedback.title", comment: "")
			default:
				break
		}
		
		return title
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == Sections.feedback.rawValue {
			switch indexPath.row {
				case Feedback.sourceCode.rawValue:
					
					let request = SettingsModels.OpenSourceCodeLink.Request()
					interactor?.openSourceCode(request)
					
				case Feedback.telegram.rawValue:
					
					let request = SettingsModels.OpenTelegramLink.Request()
					interactor?.openTelegram(request)
					
				default:
					break
			}
		}
	}
	
}

// MARK: - Display logic
extension SettingsMasterViewController: SettingsDisplayLogic {

	func displayCurrencyChange(_ viewModel: SettingsModels.ChangeCurrency.ViewModel) {

	}

	func displayAppTheme(_ viewModel: SettingsModels.ChangeAppTheme.ViewModel) {
		let sceneDelegate = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)
		sceneDelegate?.changeAppearance(viewModel.userInterfaceStyle)
	}
	
	func displaySourceCode(_ viewModel: SettingsModels.OpenSourceCodeLink.ViewModel) {
		UIApplication.shared.open(viewModel.url)
	}
	
	func displayTelegram(_ viewModel: SettingsModels.OpenTelegramLink.ViewModel) {
		UIApplication.shared.open(viewModel.url)
	}
	
}

// MARK: - CurrencyViewController delegate
extension SettingsMasterViewController: CurrencyViewControllerDelegate {
	func didSelectCurrency(_ currency: CurrencyModel) {
		let request = SettingsModels.ChangeCurrency.Request(currency: currency)
		interactor?.changeCurrency(request)
	}
}

// MARK: - Appearance delegate
extension SettingsMasterViewController: AppearanceDelegate {
	func themeDidChange(_ theme: AppearanceModel.Theme) {
		let request = SettingsModels.ChangeAppTheme.Request(theme: theme)
		interactor?.changeAppTheme(request)
	}

}
