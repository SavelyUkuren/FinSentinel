//
//  CurrencyViewController.swift
//  MoneyM
//
//  Created by savik on 08.12.2023.
//

import UIKit

class CurrencyViewController: UIViewController {

	@IBOutlet weak var currenciesTableView: UITableView!
	
	private var currenciesArray: [CurrencyModel] = []
	
	private var currencyModelManager = CurrencyModelManager()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
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
	
	
}
