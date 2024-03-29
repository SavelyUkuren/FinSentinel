//
//  SelectCategoryViewController.swift
//  MoneyM
//
//  Created by Air on 16.09.2023.
//

import UIKit

protocol SelectCategoryViewControllerDelegate: AnyObject {
    func selectButtonClicked(category: CategoryModel?)
}

protocol CategoryDisplayLogic {
	func displayCategories(_ viewModel: CategoryModels.FetchCategories.ViewModel)
}

class CategoriesViewController: UIViewController {
	
	struct CellHeight {
		static let defaultCell: CGFloat = 50
		static let cellWithSubcategories: CGFloat = 80
	}

	@IBOutlet weak var categoriesTableView: UITableView!

    public weak var delegate: SelectCategoryViewControllerDelegate?

    public var categoryType: CategoryType = .expense

    private var selectedIndex: IndexPath!

	private var categoriesArray: [CategoryModel] = []

	public var interactor: CategoryBusinessLogic?

    override func viewDidLoad() {
        super.viewDidLoad()

		setup()
		configureCategoriesTableView()

		let request = CategoryModels.FetchCategories.Request(categoryType: categoryType)
		interactor?.fetchCategories(request)
    }

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		interactor = nil
		delegate = nil
	}

	func setup() {
		let viewController = self
		let interactor = CategoryInteractor()
		let presenter = CategoryPresenter()

		viewController.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = viewController
	}

	func configureCategoriesTableView() {
		categoriesTableView.delegate = self
		categoriesTableView.dataSource = self
	}

	@IBAction func closeButtonClicked(_ sender: Any) {
		dismiss(animated: true)
	}
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		categoriesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let category = categoriesArray[indexPath.row]
		
		if let _ = category.subcategories {
			if let cellWithSubcategories = tableView.dequeueReusableCell(withIdentifier: "cellWithSubcategories") as? CategoryWithSubcategoriesTableViewCell {
				let category = categoriesArray[indexPath.row]
				
				cellWithSubcategories.categoryTitle.text = category.title
				cellWithSubcategories.iconImageView.image = UIImage(named: category.icon)
				cellWithSubcategories.categoryModel = category
				cellWithSubcategories.delegate = self
				
				return cellWithSubcategories
			}
		} else {
			if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CategoryTableViewCell {
				let category = categoriesArray[indexPath.row]
				cell.categoryTitle.text = category.title
				cell.iconImageView.image = UIImage(named: category.icon)
				return cell
			}
		}
	
        return  UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
		delegate?.selectButtonClicked(category: categoriesArray[indexPath.row])
		dismiss(animated: true)
    }

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		let category = categoriesArray[indexPath.row]
		if category.subcategories != nil {
			return CellHeight.cellWithSubcategories
		}
		
		return CellHeight.defaultCell
	}

}

// MARK: Display logic
extension CategoriesViewController: CategoryDisplayLogic {
	func displayCategories(_ viewModel: CategoryModels.FetchCategories.ViewModel) {
		categoriesArray = viewModel.categories
		categoriesTableView.reloadData()
	}
}

// MARK: CategoryWithSubcategoriesCell delegate
extension CategoriesViewController: CategoryWithSubcategoriesCellDelegate {
	func didSubcategorySelect(_ subcategory: CategoryProtocol) {
		let categoryModel = CategoryModel(id: subcategory.id,
														   title: subcategory.title,
														   icon: subcategory.icon)
		delegate?.selectButtonClicked(category: categoryModel)
		dismiss(animated: true)
	}
}
