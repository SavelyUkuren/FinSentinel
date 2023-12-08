//
//  DetailViewController.swift
//  MoneyM
//
//  Created by savik on 08.12.2023.
//

import UIKit

class DetailViewController: UIViewController {

	override func viewWillAppear(_ animated: Bool) {
		(splitViewController?.viewControllers[0] as? UINavigationController)?.popViewController(animated: false)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		
		
    }

}
