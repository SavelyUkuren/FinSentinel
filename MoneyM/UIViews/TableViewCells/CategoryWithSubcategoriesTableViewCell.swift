//
//  CategoryWithSubcategoriesTableViewCell.swift
//  MoneyM
//
//  Created by savik on 17.01.2024.
//

import UIKit

class SubcategoryCell: UICollectionViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
}

protocol CategoryWithSubcategoriesCellDelegate {
	func didSubcategorySelect(_ subcategory: CategoryProtocol)
}

class CategoryWithSubcategoriesTableViewCell: CategoryTableViewCell {

	@IBOutlet weak var subcategoriesCollectionView: UICollectionView!
	
	var categoryModel: CategoryModel?
	
	var delegate: CategoryWithSubcategoriesCellDelegate?
	
	override func awakeFromNib() {
		configureCollectionView()
	}
	
	private func configureCollectionView() {
		subcategoriesCollectionView.delegate = self
		subcategoriesCollectionView.dataSource = self
	}
	
}

extension CategoryWithSubcategoriesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		categoryModel?.subcategories?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SubcategoryCell {
			let subcategories = categoryModel?.subcategories
			
			if let unwrappedSubcategories = subcategories {
				cell.titleLabel.text = unwrappedSubcategories[indexPath.row].title
			}
			
			return cell
		}
		
		return UICollectionViewCell()
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let subcategory = categoryModel?.subcategories?[indexPath.row], let unwrappedCategoryModel = categoryModel {
			let newCategoryModel = SubcategoryModel(id: subcategory.id,
													icon: unwrappedCategoryModel.icon,
													title: subcategory.title)
			delegate?.didSubcategorySelect(newCategoryModel)
		}
	}
	
}

