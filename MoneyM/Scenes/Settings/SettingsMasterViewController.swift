//
//  SettingsMasterViewController.swift
//  MoneyM
//
//  Created by savik on 08.12.2023.
//

import UIKit

protocol SettingsDisplayLogic: AnyObject {
	func displaySettings(_ viewModel: SettingsModels.FetchSettings.ViewModel)
	func displayCurrencyChange(_ viewModel: SettingsModels.ChangeCurrency.ViewModel)
}

class SettingsMasterViewController: UITableViewController {

	var interactor: SettingsBusinessLogic?

	private var data: [SettingsModels.TableViewSectionModel] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		setup()

		let request = SettingsModels.FetchSettings.Request()
		interactor?.fetchSettings(request)

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

	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return data.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return data[section].cells.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsTableViewCell {

			cell.titleLabel.text = data[indexPath.section].cells[indexPath.row].title
			cell.iconBackgroundView.backgroundColor = data[indexPath.section].cells[indexPath.row].iconBackgroundColor
			cell.iconImageView.image = data[indexPath.section].cells[indexPath.row].icon
			cell.iconImageView.tintColor = .white

			return cell
		}

		return UITableViewCell()
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		data[section].section
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyboardID = data[indexPath.section].cells[indexPath.row].storyboardID
		let storyboard = UIStoryboard(name: "Settings", bundle: nil)
		let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID)

		(viewController as? CurrencyViewController)?.delegate = self

		splitViewController?.showDetailViewController(UINavigationController(rootViewController: viewController), sender: self)

	}

}

// MARK: - Display logic
extension SettingsMasterViewController: SettingsDisplayLogic {
	func displaySettings(_ viewModel: SettingsModels.FetchSettings.ViewModel) {
		data = viewModel.data
		tableView.reloadData()
	}

	func displayCurrencyChange(_ viewModel: SettingsModels.ChangeCurrency.ViewModel) {

	}
}

// MARK: - CurrencyViewController delegate
extension SettingsMasterViewController: CurrencyViewControllerDelegate {
	func didSelectCurrency(_ currency: CurrencyModel) {
		let request = SettingsModels.ChangeCurrency.Request(currency: currency)
		interactor?.changeCurrency(request)
	}
}
