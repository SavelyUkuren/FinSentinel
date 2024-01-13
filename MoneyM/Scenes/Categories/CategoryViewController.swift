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

		if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CategoryTableViewCell {
			let category = categoriesArray[indexPath.row]
			cell.categoryTitle.text = category.title
			cell.iconImageView.image = UIImage(systemName: category.icon)
			return cell
		}

        return  UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
		delegate?.selectButtonClicked(category: categoriesArray[indexPath.row])
		dismiss(animated: true)
    }

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		50
	}

}

// MARK: Display logic
extension CategoriesViewController: CategoryDisplayLogic {
	func displayCategories(_ viewModel: CategoryModels.FetchCategories.ViewModel) {
		categoriesArray = viewModel.categories
		categoriesTableView.reloadData()
	}
}
