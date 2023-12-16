//
//  CurrencyViewController.swift
//  MoneyM
//
//  Created by savik on 08.12.2023.
//

import UIKit

protocol CurrencyViewControllerDelegate: AnyObject {
	func didSelectCurrency(_ currency: CurrencyModel)
}

class CurrencyViewController: UIViewController {

	public var delegate: CurrencyViewControllerDelegate?

	@IBOutlet weak var currenciesTableView: UITableView!

	private var currenciesArray: [CurrencyModel] = []

	private var currencyModelManager = CurrencyModelManager()

	override func viewDidLoad() {
        super.viewDidLoad()

		title = NSLocalizedString("currency.title", comment: "")

		currenciesTableView.delegate = self
		currenciesTableView.dataSource = self

		currencyModelManager.currencies.values.forEach { model in
			currenciesArray.append(model)
		}

    }

}

// MARK: - TableView delegate
extension CurrencyViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		currenciesArray.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!

		cell.textLabel?.text = currenciesArray[indexPath.row].title

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

		let currency = currenciesArray[indexPath.row]
		delegate?.didSelectCurrency(currency)
	}

	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.accessoryType = .none
	}

}
