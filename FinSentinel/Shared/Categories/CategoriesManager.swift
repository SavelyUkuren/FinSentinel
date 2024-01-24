//
//  Categories.swift
//  MoneyM
//
//  Created by Air on 07.11.2023.
//

import Foundation

class CategoriesManager {
    public static let shared = CategoriesManager()

	public var defaultCategory = CategoryModel(id: 0, title: NSLocalizedString("uncategorised.category", comment: ""), icon: "uncategorized_category")

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
		// 53
		categoriesData.expenses.append(CategoryModel(id: 1, title: "food.category",
													 icon: "food_category",
													 subcategories: [SubcategoryModel(id: 21, icon: "food_category", title: "meat.category"),
																	 SubcategoryModel(id: 22, icon: "food_category", title: "fruits.category"),
																	 SubcategoryModel(id: 23, icon: "food_category", title: "sweets.category"),
																	 SubcategoryModel(id: 24, icon: "food_category", title: "junk_food.category")]))
		
		categoriesData.expenses.append(CategoryModel(id: 2, title: "transportation.category", icon: "transport_category",
													 subcategories: [SubcategoryModel(id: 25, icon: "transport_category", title: "public_transport.category"),
																	 SubcategoryModel(id: 26, icon: "transport_category", title: "taxi.category")]))
		
		categoriesData.expenses.append(CategoryModel(id: 3, title: "housing.category", icon: "house_category",
													 subcategories: [SubcategoryModel(id: 10, icon: "house_category", title: "utilities.category"),
																	 SubcategoryModel(id: 28, icon: "house_category", title: "furniture.category"),
																	 SubcategoryModel(id: 29, icon: "house_category", title: "dishes.category"),
																	 SubcategoryModel(id: 30, icon: "house_category", title: "household_good.category"),
																	 SubcategoryModel(id: 31, icon: "house_category", title: "repair.category")]))
		
		categoriesData.expenses.append(CategoryModel(id: 19, title: "pet.category", icon: "pet_category",
													 subcategories: [SubcategoryModel(id: 32, icon: "pet_category", title: "animal_food.category"),
																	 SubcategoryModel(id: 33, icon: "pet_category", title: "animal_health.category"),
																	 SubcategoryModel(id: 34, icon: "pet_category", title: "toys.category")]))
		
		categoriesData.expenses.append(CategoryModel(id: 20, title: "electronics.category", icon: "laptopcomputer_category",
													 subcategories: [SubcategoryModel(id: 35, icon: "laptopcomputer_category", title: "household_appliances.category")]))
		
		categoriesData.expenses.append(CategoryModel(id: 53, title: "communication.category", icon: "antenna_category",
													 subcategories: [SubcategoryModel(id: 54, icon: "antenna_category", title: "internet.category")]))
		
		categoriesData.expenses.append(CategoryModel(id: 4, title: "healthcare.category", icon: "heart_category",
													 subcategories: [SubcategoryModel(id: 36, icon: "heart_category", title: "medicines.category"),
																	 SubcategoryModel(id: 37, icon: "heart_category", title: "sport.category"),
																	 SubcategoryModel(id: 38, icon: "heart_category", title: "medical_services.category")]))
		
		categoriesData.expenses.append(CategoryModel(id: 5, title: "entertainment.category", icon: "controller_category",
													 subcategories: [SubcategoryModel(id: 39, icon: "controller_category", title: "games.category"),
																	 SubcategoryModel(id: 52, icon: "controller_category", title: "subscriptions.category"),
																	 SubcategoryModel(id: 40, icon: "controller_category", title: "rest.category"),
																	 SubcategoryModel(id: 41, icon: "controller_category", title: "cinema_concerts.category"),
																	 SubcategoryModel(id: 42, icon: "controller_category", title: "club.category"),
																	 SubcategoryModel(id: 43, icon: "controller_category", title: "hobbies_and_interests.category")]))
		
		categoriesData.expenses.append(CategoryModel(id: 6, title: "clothing.category", icon: "tshirt_category",
													 subcategories: [SubcategoryModel(id: 44, icon: "tshirt_category", title: "shoes.category"),
																	 SubcategoryModel(id: 45, icon: "tshirt_category", title: "accessories.category")]))
		
		categoriesData.expenses.append(CategoryModel(id: 7, title: "education.category", icon: "education_category",
													 subcategories: [SubcategoryModel(id: 46, icon: "education_category", title: "courses.category"),
																	 SubcategoryModel(id: 47, icon: "education_category", title: "books.category")]))
		
		categoriesData.expenses.append(CategoryModel(id: 8, title: "savings.category", icon: "savings_category",
													 subcategories: [SubcategoryModel(id: 48, icon: "savings_category", title: "investments.category"),
																	 SubcategoryModel(id: 49, icon: "savings_category", title: "money_box.category")]))
		categoriesData.expenses.append(CategoryModel(id: 9, title: "debts.category", icon: "debth_category",
													 subcategories: [SubcategoryModel(id: 50, icon: "debth_category", title: "credit.category"),
																	 SubcategoryModel(id: 51, icon: "debth_category", title: "mortgage.category")]))
		categoriesData.expenses.append(CategoryModel(id: 0, title: "uncategorised.category", icon: "uncategorized_category"))
		
		categoriesData.expenses = localizeCategories(categoriesData.expenses)
		
	}
	
	private func fillIncomeCategories() {
		categoriesData.incomes.append(CategoryModel(id: 12, title: "salary.category", icon: "salary_category"))
		categoriesData.incomes.append(CategoryModel(id: 13, title: "freelance.category", icon: "freelance_category"))
		categoriesData.incomes.append(CategoryModel(id: 14, title: "investments.category", icon: "investments_category"))
		categoriesData.incomes.append(CategoryModel(id: 15, title: "rental_income.category", icon: "rent_category"))
		categoriesData.incomes.append(CategoryModel(id: 16, title: "business.category", icon: "business_category"))
		categoriesData.incomes.append(CategoryModel(id: 17, title: "pension.category", icon: "pension_category"))
		categoriesData.incomes.append(CategoryModel(id: 0, title: "uncategorised.category", icon: "uncategorized_category"))
		
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
