//
//  HomeViewControllerFinancialSummary.swift
//  MoneyM
//
//  Created by savik on 03.01.2024.
//

import Foundation
import UIKit

extension HomeViewController: UICollectionViewDelegate,
							  UICollectionViewDataSource,
							  UICollectionViewDelegateFlowLayout{
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		financialSummaryData.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FinancialSummaryCollectionViewCell
		
		let index = indexPath.row
		
		cell.titleLabel.text = financialSummaryData[index].title
		cell.amountLabel.text = financialSummaryData[index].amountStr
		cell.amountLabel.textColor = financialSummaryData[index].amountColor
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (collectionView.bounds.width / 2) - (financialSummaryCellSpacing / 2)
		let height = (collectionView.bounds.height / 2) - (financialSummaryCellSpacing / 2)
		
		return CGSize(width: width, height: height)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		financialSummaryCellSpacing
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let startingBalanceItem = 0
		
		if indexPath.item == startingBalanceItem {
			let action = { (newBalance: String) -> Void in
				let request = Home.EditStartingBalance.Request(newBalance: newBalance)
				self.interactor?.editStartingBalance(request)
			}

			let request = Home.AlertEditStartingBalance.Request(action: action)
			interactor?.showAlertEditStartingBalance(request)
		}
	}
	
}
