//
//  Categories.swift
//  MoneyM
//
//  Created by Air on 07.11.2023.
//

import Foundation

class CategoriesManager {
    public static let shared = CategoriesManager()
    
    public static var defaultCategory = CategoryModel(id: 0, title: "Category")
    
    public var categoriesData: CategoryData!
    
    init() {
       
        guard let url = Bundle.main.url(forResource: "Categories", withExtension: "json") else { return }
        
        categoriesData = CategoryData(expenses: [], incomes: [])
        
        do {
            categoriesData = try readJSONFile(url)
        } catch {
            print ("Error! JSON text is invalid!")
        }
        
    }
    
    public func findCategoryBy(id: Int) -> CategoryModel? {
        let allCategories = categoriesData.expenses + categoriesData.incomes
        return allCategories.first { $0.id == id }
    }
    
    private func readJSONFile(_ url: URL) throws -> CategoryData {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let categories = try decoder.decode(CategoryData.self, from: data)
          
        return categories
    }
    
}
