//
//  CategoryModel.swift
//  MoneyM
//
//  Created by Air on 16.09.2023.
//

import Foundation

class CategoryModel {
    var id: Int
    var title: String
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}

class Categories {
    public static var defaultCategory = CategoryModel(id: 0, title: "Category")
    public var expenseCategories: [CategoryModel] = []
    public var incomeCategories: [CategoryModel] = []
    
    init() {
        fillExpenseCategories()
        fillIncomeCategories()
    }
    
    public func findCategoryByID(id: Int) -> CategoryModel? {
        
        if id == 0 {
            return Categories.defaultCategory
        }
        
        var category: CategoryModel?
        
        category = expenseCategories.first { $0.id == id }
        
        if category == nil {
            category = incomeCategories.first {$0.id == id }
        }
        
        return category
    }
    
    private func fillExpenseCategories() {
        expenseCategories.append(CategoryModel(id: 1, title: "Groceries"))
        expenseCategories.append(CategoryModel(id: 2, title: "Transportation"))
        expenseCategories.append(CategoryModel(id: 3, title: "Housing"))
        expenseCategories.append(CategoryModel(id: 4, title: "Healthcare"))
        expenseCategories.append(CategoryModel(id: 5, title: "Entertainment"))
        expenseCategories.append(CategoryModel(id: 6, title: "Clothing"))
        expenseCategories.append(CategoryModel(id: 7, title: "Education"))
        expenseCategories.append(CategoryModel(id: 8, title: "Savings"))
        expenseCategories.append(CategoryModel(id: 9, title: "Debts"))
        expenseCategories.append(CategoryModel(id: 10, title: "Other"))
    }
    
    private func fillIncomeCategories() {
        incomeCategories.append(CategoryModel(id: 11, title: "Salary"))
        incomeCategories.append(CategoryModel(id: 12, title: "Freelance"))
        incomeCategories.append(CategoryModel(id: 13, title: "Investments"))
        incomeCategories.append(CategoryModel(id: 14, title: "Rental Income"))
        incomeCategories.append(CategoryModel(id: 15, title: "Renting Out"))
        incomeCategories.append(CategoryModel(id: 16, title: "Business"))
        incomeCategories.append(CategoryModel(id: 17, title: "Pension"))
        incomeCategories.append(CategoryModel(id: 18, title: "Partnership Rewards"))
        incomeCategories.append(CategoryModel(id: 19, title: "Other"))
    }
    
}
