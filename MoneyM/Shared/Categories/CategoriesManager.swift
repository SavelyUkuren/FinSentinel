//
//  Categories.swift
//  MoneyM
//
//  Created by Air on 07.11.2023.
//

import Foundation

class CategoriesManager {
    public static let shared = CategoriesManager()

	public var defaultCategory = CategoryModel(id: 0, title: NSLocalizedString("uncategorised.category", comment: ""), icon: "questionmark")

    public var categoriesData: CategoryData!

	private var categoriesCache: Dictionary<Int, CategoryModel> = [:]
	private var subcategoriesCache: Dictionary<Int, SubcategoryModel> = [:]
	
    init() {

        categoriesData = CategoryData(expenses: [], incomes: [])
		
		DispatchQueue.global(qos: .background).async {
			self.fillExpenseCategories()
			self.fillIncomeCategories()
			
			self.categoriesData.expenses.forEach { model in
				self.categoriesCache[model.id] = model
				
				if model.subcategories != nil {
					model.subcategories?.forEach { subcategoryModel in
						self.subcategoriesCache[subcategoryModel.id] = subcategoryModel
					}
				}
			}
			
			self.categoriesData.incomes.forEach { model in
				self.categoriesCache[model.id] = model
				
				if model.subcategories != nil {
					model.subcategories?.forEach { subcategoryModel in
						self.subcategoriesCache[subcategoryModel.id] = subcategoryModel
					}
				}
			}
		}
		
    }
	
	public func findCategory(id: Int) -> CategoryProtocol? {
		if let category = categoriesCache[id] {
			return category
		} else if let subcategory = subcategoriesCache[id]{
			return subcategory
		}
		return nil
	}

    public func findCategoryBy2(id: Int) -> CategoryModel? {
        return categoriesCache[id]
    }
	
	public func findSubcategoryBy2(id: Int) -> SubcategoryModel? {
		return subcategoriesCache[id]
	}
	
	private func fillExpenseCategories() {
		categoriesData.expenses.append(CategoryModel(id: 1, title: "food.category",
													 icon: "fork.knife",
													 subcategories: [SubcategoryModel(id: 21, icon: "fork.knife", title: "meat.category"),
																	 SubcategoryModel(id: 22, icon: "fork.knife", title: "fruits.category"),
																	 SubcategoryModel(id: 23, icon: "fork.knife", title: "sweets.category"),
																	 SubcategoryModel(id: 24, icon: "fork.knife", title: "junk_food.category")]))
		
		categoriesData.expenses.append(CategoryModel(id: 2, title: "transportation.category", icon: "car.fill",
													 subcategories: [SubcategoryModel(id: 25, icon: "car.fill", title: "public_transport.category"),
																	 SubcategoryModel(id: 26, icon: "car.fill", title: "taxi.category")]))
		
		categoriesData.expenses.append(CategoryModel(id: 3, title: "housing.category", icon: "house.fill",
													 subcategories: [SubcategoryModel(id: 10, icon: "house.fill", title: "utilities.category"),
																	 SubcategoryModel(id: 28, icon: "house.fill", title: "furniture.category"),
																	 SubcategoryModel(id: 29, icon: "house.fill", title: "dishes.category"),
																	 SubcategoryModel(id: 30, icon: "house.fill", title: "household_good.category"),
																	 SubcategoryModel(id: 31, icon: "house.fill", title: "repair.category")]))
		
		categoriesData.expenses.append(CategoryModel(id: 19, title: "pet.category", icon: "pawprint.fill",
													 subcategories: [SubcategoryModel(id: 32, icon: "pawprint.fill", title: "animal_food.category"),
																	 SubcategoryModel(id: 33, icon: "pawprint.fill", title: "animal_health.category"),
																	 SubcategoryModel(id: 34, icon: "pawprint.fill", title: "toys.category")]))
		
		categoriesData.expenses.append(CategoryModel(id: 20, title: "electronics.category", icon: "laptopcomputer",
													 subcategories: [SubcategoryModel(id: 35, icon: "laptopcomputer", title: "household_appliances.category")]))
		
		categoriesData.expenses.append(CategoryModel(id: 4, title: "healthcare.category", icon: "staroflife.fill",
													 subcategories: [SubcategoryModel(id: 36, icon: "staroflife.fill", title: "medicines.category"),
																	 SubcategoryModel(id: 37, icon: "staroflife.fill", title: "sport.category"),
																	 SubcategoryModel(id: 38, icon: "staroflife.fill", title: "medical_services.category")]))
		
		categoriesData.expenses.append(CategoryModel(id: 5, title: "entertainment.category", icon: "gamecontroller.fill",
													 subcategories: [SubcategoryModel(id: 39, icon: "gamecontroller.fill", title: "games.category"),
																	 SubcategoryModel(id: 40, icon: "gamecontroller.fill", title: "rest.category"),
																	 SubcategoryModel(id: 41, icon: "gamecontroller.fill", title: "cinema_concerts.category"),
																	 SubcategoryModel(id: 42, icon: "gamecontroller.fill", title: "club.category"),
																	 SubcategoryModel(id: 43, icon: "gamecontroller.fill", title: "hobbies_and_interests.category")]))
		categoriesData.expenses.append(CategoryModel(id: 6, title: "clothing.category", icon: "tshirt.fill",
													 subcategories: [SubcategoryModel(id: 44, icon: "tshirt.fill", title: "shoes.category"),
																	 SubcategoryModel(id: 45, icon: "tshirt.fill", title: "accessories.category")]))
		categoriesData.expenses.append(CategoryModel(id: 7, title: "education.category", icon: "book.fill",
													 subcategories: [SubcategoryModel(id: 46, icon: "book.fill", title: "courses.category"),
																	 SubcategoryModel(id: 47, icon: "book.fill", title: "books.category")]))
		categoriesData.expenses.append(CategoryModel(id: 8, title: "savings.category", icon: "banknote.fill",
													 subcategories: [SubcategoryModel(id: 48, icon: "banknote.fill", title: "investments.category"),
																	 SubcategoryModel(id: 49, icon: "banknotes.fill", title: "money_box.category")]))
		categoriesData.expenses.append(CategoryModel(id: 9, title: "debts.category", icon: "creditcard.fill",
													 subcategories: [SubcategoryModel(id: 50, icon: "creditcard.fill", title: "credit.category"),
																	 SubcategoryModel(id: 51, icon: "creditcard.fill", title: "mortgage.category")]))
//		categoriesData.expenses.append(CategoryModel(id: 10, title: "utilities.category", icon: "hammer.fill"))
		categoriesData.expenses.append(CategoryModel(id: 11, title: "uncategorised.category", icon: "questionmark"))
		
		categoriesData.expenses = localizeCategories(categoriesData.expenses)
		
	}
	
	private func fillIncomeCategories() {
		categoriesData.incomes.append(CategoryModel(id: 12, title: "salary.category", icon: "dollarsign.circle.fill"))
		categoriesData.incomes.append(CategoryModel(id: 13, title: "freelance.category", icon: "brain.head.profile"))
		categoriesData.incomes.append(CategoryModel(id: 14, title: "investments.category", icon: "chart.pie.fill"))
		categoriesData.incomes.append(CategoryModel(id: 15, title: "rental_income.category", icon: "house.fill"))
		categoriesData.incomes.append(CategoryModel(id: 16, title: "business.category", icon: "briefcase.fill"))
		categoriesData.incomes.append(CategoryModel(id: 17, title: "pension.category", icon: "person.2.fill"))
		categoriesData.incomes.append(CategoryModel(id: 18, title: "uncategorised.category", icon: "questionmark"))
		
		categoriesData.incomes = localizeCategories(categoriesData.incomes)
	}

	private func localizeCategories(_ categories: [CategoryModel]) -> [CategoryModel] {
		categories.map { model in
			
			var subcategories = model.subcategories
			
			if let unwrappedSubcategories = subcategories {
				let localizedSubcategories = unwrappedSubcategories.map { subcategoryModel in
					SubcategoryModel(id: subcategoryModel.id,
									 icon: subcategoryModel.icon,
									 title: NSLocalizedString(subcategoryModel.title, comment: ""))
				}
				subcategories = localizedSubcategories
			}
			
			
			return CategoryModel(id: model.id,
						  title: NSLocalizedString(model.title, comment: ""),
						  icon: model.icon,
						  subcategories: subcategories)
		}
	}

}
