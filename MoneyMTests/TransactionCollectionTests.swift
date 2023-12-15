//
//  TransactionCollectionTests.swift
//  MoneyMTests
//
//  Created by savik on 15.12.2023.
//

import XCTest
@testable import MoneyM

final class TransactionCollectionTests: XCTestCase {
	
	var transactionCollection: TransactionCollection!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		transactionCollection = TransactionCollection()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		transactionCollection = nil
    }

	func testAdd() {
		
		let date = customDate(day: 1, month: 10, year: 2023)
		
		let transaction = TransactionModel()
		transaction.amount = 120
		transaction.mode = .Expense
		transaction.date = date
		transaction.categoryID = 1
		transaction.note = "Test note"
		
		transactionCollection.add(transaction)
		
		// Checking transactions count in collection
		XCTAssert(transactionCollection.data[0].date == date)
		XCTAssertEqual(transactionCollection.data.count, 1)
		XCTAssertEqual(transactionCollection.data[0].transactions.count, 1)
		
		// Checking transaction in collection
		let testsTransaction = transactionCollection.data[0].transactions[0]
		XCTAssertEqual(testsTransaction.amount, 120)
		XCTAssertEqual(testsTransaction.mode, .Expense)
		XCTAssertEqual(testsTransaction.date, date)
		XCTAssertEqual(testsTransaction.categoryID, 1)
		XCTAssertEqual(testsTransaction.note, "Test note")
	}
	
	func testEditByID() {
		
		let date = customDate(day: 13, month: 4, year: 2023)
		
		let transaction = TransactionModel()
		transaction.amount = 99
		transaction.mode = .Income
		transaction.date = date
		transaction.categoryID = 4
		transaction.note = "Hello world"
		
		transactionCollection.add(transaction)
		
		let newDate = customDate(day: 4, month: 5, year: 2022)
		let editedTransaction = TransactionModel()
		editedTransaction.id = transaction.id
		editedTransaction.amount = 140
		editedTransaction.mode = .Expense
		editedTransaction.date = newDate
		editedTransaction.categoryID = 5
		editedTransaction.note = "Hello"
		
		transactionCollection.editBy(id: transaction.id, newTransaction: editedTransaction)
		
		XCTAssertEqual(transaction.id, editedTransaction.id)
		
		let testsTransaction = transactionCollection.data[0].transactions[0]
		XCTAssertEqual(testsTransaction.amount, editedTransaction.amount)
		XCTAssertEqual(testsTransaction.mode, editedTransaction.mode)
		XCTAssertEqual(testsTransaction.date, editedTransaction.date)
		XCTAssertEqual(testsTransaction.categoryID, editedTransaction.categoryID)
		XCTAssertEqual(testsTransaction.note, editedTransaction.note)
	}
	
	func testRemoveByID() {
		let date = customDate(day: 1, month: 10, year: 2023)
		
		let transaction = TransactionModel()
		transaction.amount = 120
		transaction.mode = .Expense
		transaction.date = date
		transaction.categoryID = 1
		transaction.note = "Test note"
		
		transactionCollection.add(transaction)
		
		XCTAssertEqual(transactionCollection.data.count, 1)
		XCTAssertEqual(transactionCollection.data[0].transactions.count, 1)
		
		transactionCollection.removeBy(transaction.id)
		
		XCTAssertEqual(transactionCollection.data.count, 0)
	}
	
	func testFinancialSummary() {
		
		transactionCollection.setStartingBalance(1000)
		
		let transaction1 = TransactionModel()
		transaction1.amount = 120
		transaction1.mode = .Expense
		transaction1.date = Date()
		
		let transaction2 = TransactionModel()
		transaction2.amount = 100
		transaction2.mode = .Expense
		transaction2.date = Date()
		
		let transaction3 = TransactionModel()
		transaction3.amount = 500
		transaction3.mode = .Income
		transaction3.date = Date()
		
		transactionCollection.add([transaction1, transaction2, transaction3])
		
		let summary = transactionCollection.summary
		
		XCTAssertEqual(summary.expense, -220)
		XCTAssertEqual(summary.income, 500)
		XCTAssertEqual(summary.balance, 1280)
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
