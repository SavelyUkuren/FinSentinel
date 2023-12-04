//
//  ButtonChoiceView.swift
//  MoneyM
//
//  Created by Air on 07.11.2023.
//

import Foundation
import UIKit

class ButtonChoiceView: UIView {
    
    enum Buttons {
        case First, Second
    }
    
    public var selectedButton: Buttons = .First
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let firstButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.layer.cornerRadius = UIStyle.CornerRadius
        return button
    }()
    
    private let secondButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.layer.cornerRadius = UIStyle.CornerRadius
        return button
    }()
	
	public var accentColor: UIColor = Settings.shared.model.accentColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureStackView()
        configureButtons()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
		
		configureStackView()
		configureButtons()
    }
    
    public func setButtonTitle(_ title: String, button: Buttons) {
        switch button {
        case .First:
            firstButton.setTitle(title, for: .normal)
        case .Second:
            secondButton.setTitle(title, for: .normal)
        }
    }
    
    public func selectButton(_ button: Buttons) {
        switch button {
        case .First:
            firstButtonClicked()
        case .Second:
            secondButtonClicked()
        }
    }
    
    private func configureStackView() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(firstButton)
        stackView.addArrangedSubview(secondButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    private func configureButtons() {
		firstButton.backgroundColor = .quaternarySystemFill
        secondButton.backgroundColor = .quaternarySystemFill
        
        firstButton.addTarget(self, action: #selector(firstButtonClicked), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(secondButtonClicked), for: .touchUpInside)
        
        firstButtonClicked()
    }
    
    @objc
    private func firstButtonClicked() {
        secondButton.backgroundColor = .quaternarySystemFill
        secondButton.setTitleColor(accentColor, for: .normal)

        firstButton.setTitleColor(.white, for: .normal)
        firstButton.backgroundColor = accentColor
        
        selectedButton = .First
    }
    
    @objc
    private func secondButtonClicked() {
        firstButton.backgroundColor = .quaternarySystemFill
        firstButton.setTitleColor(accentColor, for: .normal)

        secondButton.setTitleColor(.white, for: .normal)
        secondButton.backgroundColor = accentColor
        
        selectedButton = .Second
    }
    
}
