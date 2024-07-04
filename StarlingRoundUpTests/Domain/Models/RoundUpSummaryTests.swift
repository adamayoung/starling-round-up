//
//  RoundUpSummaryTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 04/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class RoundUpSummaryTests: XCTestCase {

    func testIDHasCorrectValue() {
        let accountID = "1"
        let startDate = Date(timeIntervalSince1970: 0)
        let endDate = Date(timeIntervalSince1970: 1000)
        let dateRange = startDate ..< endDate
        let expectedID = "\(accountID)"
            + "-\(dateRange.lowerBound.timeIntervalSince1970)-"
            + "\(dateRange.upperBound.timeIntervalSince1970)"

        let summary = Self.createRoundUpSummary(accountID: accountID, dateRange: dateRange)

        XCTAssertEqual(summary.id, expectedID)
    }

    func testHasAvailableAccountBalanceWhenAccountBalanceIsLessThanAmountReturnsFalse() {
        let summary = Self.createRoundUpSummary(
            amount: Money(minorUnits: 10, currency: "GBP"),
            accountBalance: Money(minorUnits: 0, currency: "GBP")
        )

        XCTAssertFalse(summary.hasAvailableAccountBalance)
    }

    func testHasAvailableAccountBalanceWhenAccountBalanceIsEqualToAmountReturnsTrue() {
        let summary = Self.createRoundUpSummary(
            amount: Money(minorUnits: 10, currency: "GBP"),
            accountBalance: Money(minorUnits: 10, currency: "GBP")
        )

        XCTAssertTrue(summary.hasAvailableAccountBalance)
    }

    func testHasAvailableAccountBalanceWhenAccountBalanceIsGreaterThanAmountReturnsTrue() {
        let summary = Self.createRoundUpSummary(
            amount: Money(minorUnits: 10, currency: "GBP"),
            accountBalance: Money(minorUnits: 100, currency: "GBP")
        )

        XCTAssertTrue(summary.hasAvailableAccountBalance)
    }

    func testIsRoundUpAvailableWhenAmountIsZeroReturnsFalse() {
        let summary = Self.createRoundUpSummary(amount: Money(minorUnits: 0, currency: "GBP"))

        XCTAssertFalse(summary.isRoundUpAvailable)
    }

    func testIsRoundUpAvailableWhenAmountIsGreaterThanZeroReturnsTrue() {
        let summary = Self.createRoundUpSummary(amount: Money(minorUnits: 1, currency: "GBP"))

        XCTAssertTrue(summary.isRoundUpAvailable)
    }

}

extension RoundUpSummaryTests {

    private static func createRoundUpSummary(
        accountID: String = "1",
        amount: Money = Money(minorUnits: 0, currency: "GBP"),
        dateRange: Range<Date> = Date(timeIntervalSince1970: 0) ..< Date(timeIntervalSince1970: 1000),
        transactionsCount: Int = 10,
        accountBalance: Money = Money(minorUnits: 0, currency: "GBP")
    ) -> RoundUpSummary {
        RoundUpSummary(
            accountID: accountID,
            amount: amount,
            dateRange: dateRange,
            transactionsCount: transactionsCount,
            accountBalance: accountBalance
        )
    }

}
