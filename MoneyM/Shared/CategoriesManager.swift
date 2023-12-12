//
//  Categories.swift
//  MoneyM
//
//  Created by Air on 07.11.2023.
//

import Foundation

class CategoriesManager {
    public static let shared = CategoriesManager()
    
    public var defaultCategory = CategoryModel(id: 0, title: NSLocalizedString("category.title", comment: ""))
    
    public var categoriesData: CategoryData!
    
    init() {
       
        guard let url = Bundle.main.url(forResource: "Categories", withExtension: "json") else { return }
        
        categoriesData = CategoryData(expenses: [], incomes: [])
        
        do {
            categoriesData = try readJSONFile(url)
			categoriesData.expenses = localizeCategories(categoriesData.expenses)
			categoriesData.incomes = localizeCategories(categoriesData.incomes)
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
    
	private func localizeCategories(_ categories: [CategoryModel]) -> [CategoryModel] {
		categories.map { model in
			CategoryModel(id: model.id, title: NSLocalizedString(model.title, comment: ""))
		}
	}
	
}
