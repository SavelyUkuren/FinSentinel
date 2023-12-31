//
//  CoreDataManagerTests.swift
//  MoneyMTests
//
//  Created by savik on 15.12.2023.
//

import XCTest
@testable import MoneyM

final class CoreDataManagerTests: XCTestCase {

	var coreDataManager: CoreDataManager!

	let transactionCreate: (_ date: Date) -> TransactionModel = { (date: Date) -> (TransactionModel) in

		let model = TransactionModel()
		model.amount = 113
		model.mode = .expense
		model.date = date
		model.categoryID = 5
		model.note = "Test"

		return model
	}

    override func setUpWithError() throws {
		coreDataManager = CoreDataManager()
    }

    override func tearDownWithError() throws {
		coreDataManager = nil
    }

	func testAdd() {
		let date = customDate(day: 1, month: 1, year: 1)!

		let transaction = transactionCreate(date)
		coreDataManager.add(transaction)

		let transactionsArray = coreDataManager.load(year: 1, month: 1)

		XCTAssert(transactionsArray.count == 1)
		XCTAssert(transactionsArray[0].amount == transaction.amount)
		XCTAssert(transactionsArray[0].categoryID == transaction.categoryID)
		XCTAssert(transactionsArray[0].mode == transaction.mode)
		XCTAssert(transactionsArray[0].date == transaction.date)
		XCTAssert(transactionsArray[0].note == transaction.note)
		XCTAssert(transactionsArray[0].id == transaction.id)
	}

	func testEdit() {
		let date = customDate(day: 2, month: 2, year: 2)!

		let transaction = transactionCreate(date)
		coreDataManager.add(transaction)

		let editedTransaction = TransactionModel()
		editedTransaction.id = transaction.id
		editedTransaction.amount = 100
		editedTransaction.mode = .expense
		editedTransaction.date = customDate(day: 2, month: 2, year: 2)
		editedTransaction.categoryID = 3

		coreDataManager.edit(transaction.id, editedTransaction)

		let transactionsArray = coreDataManager.load(year: 2, month: 2)
		XCTAssert(transactionsArray.count == 1)
		XCTAssert(transactionsArray[0].amount == editedTransaction.amount)
		XCTAssert(transactionsArray[0].categoryID == editedTransaction.categoryID)
		XCTAssert(transactionsArray[0].mode == editedTransaction.mode)
		XCTAssert(transactionsArray[0].date == editedTransaction.date)
		XCTAssert(transactionsArray[0].note == editedTransaction.note)
		XCTAssert(transactionsArray[0].id == editedTransaction.id)
	}

	func testDelete() {

		let date = customDate(day: 3, month: 3, year: 3)!

		let transaction = transactionCreate(date)
		coreDataManager.add(transaction)

		coreDataManager.delete(transaction.id)

		XCTAssert(coreDataManager.load(year: 3, month: 3).count == 0)
	}

	func testEditStartingBalance() {

		let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

		let date = customDate(day: 4, month: 4, year: 4)!

		let transaction = transactionCreate(date)

		coreDataManager.add(transaction)

		coreDataManager.editStartingBalance(year: 4, month: 4, newBalance: 90)

		do {
			let request = FolderEntity.fetchRequest()
			request.predicate = NSPredicate(format: "year == %i && month == %i", 4, 4)

			let folder = try context?.fetch(request).first
			XCTAssert(folder?.startingBalance == 90)
		} catch {
			XCTAssert(false)
		}

	}

	func customDate(day: Int, month: Int, year: Int) -> Date? {
		var dateComponents = DateComponents()
		dateComponents.day = day
		dateComponents.month = month
		dateComponents.year = year

		return Calendar.current.date(from: dateComponents)
	}

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
