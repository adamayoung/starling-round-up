//
//  TransactionMapperTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

@testable import StarlingRoundUp
import XCTest

final class TransactionMapperTests: XCTestCase {

    func testMapID() {
        let dataModel = Self.createTransactionDataModel(feedItemUid: "1")

        let transaction = TransactionMapper.map(dataModel)

        XCTAssertEqual(transaction.id, "1")
    }

    func testMapAmount() {
        let dataModel = Self.createTransactionDataModel(amount: MoneyDataModel(minorUnits: 1234, currency: "GBP"))

        let transaction = TransactionMapper.map(dataModel)

        XCTAssertEqual(transaction.amount, Money(minorUnits: 1234, currency: "GBP"))
    }

    func testMapDirection() {
        let dataModel = Self.createTransactionDataModel(direction: .in)

        let transaction = TransactionMapper.map(dataModel)

        XCTAssertEqual(transaction.direction, .incoming)
    }

}

extension TransactionMapperTests {

    private static func createTransactionDataModel(
        feedItemUid: String = "1",
        categoryUid: String = "a",
        amount: MoneyDataModel = MoneyDataModel(minorUnits: 0, currency: "GBP"),
        direction: TransactionDirectionDataModel = .in,
        transactionTime: Date = Date(timeIntervalSince1970: 0),
        settlementTime: Date = Date(timeIntervalSince1970: 0),
        updatedAt: Date = Date(timeIntervalSince1970: 0)
    ) -> TransactionDataModel {
        TransactionDataModel(
            feedItemUid: feedItemUid,
            categoryUid: categoryUid,
            amount: amount,
            direction: direction,
            transactionTime: transactionTime,
            settlementTime: settlementTime,
            updatedAt: updatedAt
        )
    }

}
