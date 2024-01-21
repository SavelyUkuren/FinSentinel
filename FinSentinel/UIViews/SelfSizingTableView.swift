//
//  SelfSizingTableView.swift
//  MoneyM
//
//  Created by savik on 18.01.2024.
//

import UIKit

class SelfSizingTableView: UITableView {
	override var contentSize:CGSize {
		didSet {
			invalidateIntrinsicContentSize()
		}
	}
	
	override var intrinsicContentSize: CGSize {
		layoutIfNeeded()
		return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
	}
}
