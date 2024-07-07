//
//  RoundUpSummaryTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 04/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class RoundUpSummaryTests: XCTestCase {

    func testIDHasCorrectValue() throws {
        let accountID = try XCTUnwrap(UUID(uuidString: "E824387A-B85A-4C26-B00F-FD5E104DF697"))
        let startDate = Date(timeIntervalSince1970: 0)
        let endDate = Date(timeIntervalSince1970: 1000)
        let dateRange = startDate ..< endDate
        let expectedID = "\(accountID)"
            + "-\(dateRange.lowerBound.timeIntervalSince1970)-"
            + "\(dateRange.upperBound.timeIntervalSince1970)"

        let summary = Self.createRoundUpSummary(accountID: accountID, dateRange: dateRange)

        XCTAssertEqual(summary.id, expectedID)
    }

    func testHasAvailableAccountBalanceWhenAccountBalanceIsLessThanAmountReturnsFalse() throws {
        let accountID = try XCTUnwrap(UUID(uuidString: "E824387A-B85A-4C26-B00F-FD5E104DF697"))
        let summary = Self.createRoundUpSummary(
            accountID: accountID,
            amount: Money(minorUnits: 10, currency: "GBP"),
            accountBalance: Money(minorUnits: 0, currency: "GBP")
        )

        XCTAssertFalse(summary.hasSufficentFundsForTransfer)
    }

    func testHasSufficentFundsForTransferWhenAccountBalanceIsEqualToAmountReturnsTrue() throws {
        let accountID = try XCTUnwrap(UUID(uuidString: "E824387A-B85A-4C26-B00F-FD5E104DF697"))
        let summary = Self.createRoundUpSummary(
            accountID: accountID,
            amount: Money(minorUnits: 10, currency: "GBP"),
            accountBalance: Money(minorUnits: 10, currency: "GBP")
        )

        XCTAssertTrue(summary.hasSufficentFundsForTransfer)
    }

    func testHasSufficentFundsForTransferWhenAccountBalanceIsGreaterThanAmountReturnsTrue() throws {
        let accountID = try XCTUnwrap(UUID(uuidString: "E824387A-B85A-4C26-B00F-FD5E104DF697"))
        let summary = Self.createRoundUpSummary(
            accountID: accountID,
            amount: Money(minorUnits: 10, currency: "GBP"),
            accountBalance: Money(minorUnits: 100, currency: "GBP")
        )

        XCTAssertTrue(summary.hasSufficentFundsForTransfer)
    }

    func testIsRoundUpAvailableWhenAmountIsZeroReturnsFalse() throws {
        let accountID = try XCTUnwrap(UUID(uuidString: "E824387A-B85A-4C26-B00F-FD5E104DF697"))
        let summary = Self.createRoundUpSummary(accountID: accountID, amount: Money(minorUnits: 0, currency: "GBP"))

        XCTAssertFalse(summary.isRoundUpAvailable)
    }

    func testIsRoundUpAvailableWhenAmountIsGreaterThanZeroReturnsTrue() throws {
        let accountID = try XCTUnwrap(UUID(uuidString: "E824387A-B85A-4C26-B00F-FD5E104DF697"))
        let summary = Self.createRoundUpSummary(accountID: accountID, amount: Money(minorUnits: 1, currency: "GBP"))

        XCTAssertTrue(summary.isRoundUpAvailable)
    }

    func testIsDateRangeEndInFutureWhenInPastReturnsFalse() throws {
        let accountID = try XCTUnwrap(UUID(uuidString: "E824387A-B85A-4C26-B00F-FD5E104DF697"))
        let fromDate = Date(timeIntervalSince1970: 0)
        let toDate = Date(timeIntervalSince1970: 1000)
        let dateRange = fromDate ..< toDate
        let summary = Self.createRoundUpSummary(accountID: accountID, dateRange: dateRange)

        XCTAssertFalse(summary.isDateRangeEndInFuture)
    }

    func testIsDateRangeEndInFutureWhenInFutureReturnsTrue() throws {
        let accountID = try XCTUnwrap(UUID(uuidString: "E824387A-B85A-4C26-B00F-FD5E104DF697"))
        let toDate = Date.distantFuture
        let fromDate = toDate.addingTimeInterval(-1000)

        let dateRange = fromDate ..< toDate
        let summary = Self.createRoundUpSummary(accountID: accountID, dateRange: dateRange)

        XCTAssertTrue(summary.isDateRangeEndInFuture)
    }

}

extension RoundUpSummaryTests {

    private static func createRoundUpSummary(
        accountID: UUID,
        amount: Money = Money(minorUnits: 0, currency: "GBP"),
        dateRange: Range<Date> = Date(timeIntervalSince1970: 0) ..< Date(timeIntervalSince1970: 1000),
        timeWindow: RoundUpTimeWindow = .week,
        accountBalance: Money = Money(minorUnits: 0, currency: "GBP"),
        availableSavingsGoals: [SavingsGoal] = []
    ) -> RoundUpSummary {
        RoundUpSummary(
            accountID: accountID,
            amount: amount,
            dateRange: dateRange,
            timeWindow: timeWindow,
            accountBalance: accountBalance,
            availableSavingsGoals: availableSavingsGoals
        )
    }

}
