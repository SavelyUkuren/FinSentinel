//
//  ViewController.swift
//  MoneyM
//
//  Created by Air on 30.08.2023.
//

import UIKit

class HomeViewController: UIViewController {

    private var homeView: HomeView!
    
    private var data = ["1", "2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...100 {
            data.append("\(i)")
        }
        
        homeView = HomeView(frame: self.view.frame)
        homeView.setTransactionsTableViewDelegate(delegate: self)
        homeView.setTransactionsTableViewDataSource(dataSource: self)
        
        self.view = homeView
        
    }


}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = data[indexPath.row]
        homeView.updateTransactionTableView()
        return cell
    }
    
    
}
