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

    func testMapID() throws {
        let transactionID = try XCTUnwrap(UUID(uuidString: "429E13F3-0767-4ECE-A6AA-6DD2D0E416DC"))
        let dataModel = Self.createTransactionDataModel(feedItemUid: transactionID)

        let transaction = TransactionMapper.map(dataModel)

        XCTAssertEqual(transaction.id, transactionID)
    }

    func testMapAmount() throws {
        let transactionID = try XCTUnwrap(UUID(uuidString: "429E13F3-0767-4ECE-A6AA-6DD2D0E416DC"))
        let dataModel = Self.createTransactionDataModel(
            feedItemUid: transactionID,
            amount: MoneyDataModel(minorUnits: 1234, currency: "GBP")
        )

        let transaction = TransactionMapper.map(dataModel)

        XCTAssertEqual(transaction.amount, Money(minorUnits: 1234, currency: "GBP"))
    }

    func testMapDirection() throws {
        let transactionID = try XCTUnwrap(UUID(uuidString: "429E13F3-0767-4ECE-A6AA-6DD2D0E416DC"))
        let dataModel = Self.createTransactionDataModel(feedItemUid: transactionID, direction: .in)

        let transaction = TransactionMapper.map(dataModel)

        XCTAssertEqual(transaction.direction, .incoming)
    }

}

extension TransactionMapperTests {

    private static func createTransactionDataModel(
        feedItemUid: UUID,
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
