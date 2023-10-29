//
//  SelectCategoryView.swift
//  MoneyM
//
//  Created by Air on 16.09.2023.
//

import UIKit

protocol SelectCategoryViewDelegate {
    func selectButtonClicked()
}

class SelectCategoryView: UIView {
    
    public var delegate: SelectCategoryViewDelegate?
    
    public var categories: [CategoryModel] = []
    
    private var categoriesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var selectButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = UIStyle.CornerRadius
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        configureSelectButton()
        configureCategoryiesTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setCategoriesTableViewDelegate(delegate: UITableViewDelegate) {
        categoriesTableView.delegate = delegate
    }
    
    public func setCategoriesTableViewDataSource(dataSource: UITableViewDataSource) {
        categoriesTableView.dataSource = dataSource
    }
    
    @objc
    private func selectButtonClicked() {
        delegate?.selectButtonClicked()
    }
    
    private func configureCategoryiesTableView() {
        addSubview(categoriesTableView)
        
        categoriesTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            categoriesTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoriesTableView.bottomAnchor.constraint(equalTo: selectButton.topAnchor, constant: -16)
        ])
    }
    
    private func configureSelectButton() {
        addSubview(selectButton)
        
        NSLayoutConstraint.activate([
            selectButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            selectButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            selectButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            selectButton.heightAnchor.constraint(equalToConstant: UIStyle.ButtonHeight)
        ])
        
        selectButton.addTarget(self, action: #selector(selectButtonClicked), for: .touchUpInside)
    }
    
}


