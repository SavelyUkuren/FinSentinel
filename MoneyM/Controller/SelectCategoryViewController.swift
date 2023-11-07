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
    
    public var categoryType: TransactionModel.Mode = .Expense
    
    private var selectCategoryView: SelectCategoryView!
    
    private var selectedIndex: IndexPath!
    
    private var categories = CategoriesManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectCategoryView = SelectCategoryView(frame: view.frame)
        selectCategoryView.translatesAutoresizingMaskIntoConstraints = false
        
        selectCategoryView.delegate = self
        
        selectCategoryView.setCategoriesTableViewDelegate(delegate: self)
        selectCategoryView.setCategoriesTableViewDataSource(dataSource: self)
        
        self.view = selectCategoryView
        
    }
    
}

extension SelectCategoryViewController: SelectCategoryViewDelegate {
    
    func selectButtonClicked() {
        guard selectedIndex != nil else {
            dismiss(animated: true)
            return
        }
        
        var category: CategoryModel?
        
        switch categoryType {
        case .Expense:
            category = categories.categoriesData.expenses[selectedIndex.row]
        case .Income:
            category = categories.categoriesData.incomes[selectedIndex.row]
        }
        
        delegate?.selectButtonClicked(category: category)
        
        dismiss(animated: true)
    }
    
}

extension SelectCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch categoryType {
        case .Expense:
            return categories.categoriesData.expenses.count
        case .Income:
            return categories.categoriesData.incomes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        switch categoryType {
        case .Expense:
            cell.textLabel?.text = categories.categoriesData.expenses[indexPath.row].title
        case .Income:
            cell.textLabel?.text = categories.categoriesData.incomes[indexPath.row].title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
    }
    
}
