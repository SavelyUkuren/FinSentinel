//
//  SelectCategoryViewController.swift
//  MoneyM
//
//  Created by Air on 16.09.2023.
//

import UIKit

protocol SelectCategoryViewControllerDelegate {
    func selectButtonClicked(category: CategoryModel?)
}

class SelectCategoryViewController: UIViewController {
    
    public var delegate: SelectCategoryViewControllerDelegate?
    
    public var transactionMode: TransactionModel.Mode = .Expense
    
    private var selectCategoryView: SelectCategoryView!
    
    private var selectedIndex: IndexPath!
    
    private var categories: Categories!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectCategoryView = SelectCategoryView(frame: view.frame)
        selectCategoryView.translatesAutoresizingMaskIntoConstraints = false
        
        selectCategoryView.delegate = self
        
        selectCategoryView.setCategoriesTableViewDelegate(delegate: self)
        selectCategoryView.setCategoriesTableViewDataSource(dataSource: self)
        
        self.view = selectCategoryView
        
        categories = Categories()
    }
    
}

extension SelectCategoryViewController: SelectCategoryViewDelegate {
    
    func selectButtonClicked() {
        guard selectedIndex != nil else {
            dismiss(animated: true)
            return
        }
        
        var category: CategoryModel?
        
        switch transactionMode {
        case .Expense:
            category = categories.expenseCategories[selectedIndex.row]
        case .Income:
            category = categories.incomeCategories[selectedIndex.row]
        }
        
        delegate?.selectButtonClicked(category: category)
        
        dismiss(animated: true)
    }
    
}

extension SelectCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch transactionMode {
        case .Expense:
            return categories.expenseCategories.count
        case .Income:
            return categories.incomeCategories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        switch transactionMode {
        case .Expense:
            cell.textLabel?.text = categories.expenseCategories[indexPath.row].title
        case .Income:
            cell.textLabel?.text = categories.incomeCategories[indexPath.row].title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
    }
    
}
