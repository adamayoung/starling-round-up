//
//  RoundUpTimeWindowTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 04/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class RoundUpTimeWindowTests: XCTestCase {

    var dateFormatter: ISO8601DateFormatter!

    override func setUp() {
        super.setUp()
        dateFormatter = ISO8601DateFormatter()
    }

    override func tearDown() {
        dateFormatter = ISO8601DateFormatter()
        super.tearDown()
    }

    func testDateRangeForWeekWhenContainingDateIsMidWeekUsingGMTHasCorrectStartDate() throws {
        let timeWindow = RoundUpTimeWindow.week
        // Wednesday, 3rd July 2024 10:00:00 UTC
        let date = try XCTUnwrap(dateFormatter.date(from: "2024-07-03T10:00:00Z"))
        // Monday, 1st July 2024 00:00:00 UTC
        let expectedStartDate = try XCTUnwrap(dateFormatter.date(from: "2024-07-01T00:00:00Z"))

        let range = timeWindow.dateRange(containing: date, in: .gmt)

        XCTAssertEqual(range.lowerBound, expectedStartDate)
    }

    func testDateRangeForWeekWhenContainingDateIsMidWeekUsingGMTPlusOneHasCorrectStartDate() throws {
        let timeWindow = RoundUpTimeWindow.week
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 60 * 60))
        // Wednesday, 3rd July 2024 10:00:00 UTC
        let date = try XCTUnwrap(dateFormatter.date(from: "2024-07-03T10:00:00Z"))
        // Monday, 1st July 2024 01:00:00 +01:00
        let expectedStartDate = try XCTUnwrap(dateFormatter.date(from: "2024-07-01T01:00:00Z"))

        let range = timeWindow.dateRange(containing: date, in: timeZone)

        XCTAssertEqual(range.lowerBound, expectedStartDate)
    }

    func testDateRangeForWeekWhenContainingDateIsMidWeekUsingGMTHasCorrectEndDate() throws {
        let timeWindow = RoundUpTimeWindow.week
        // Wednesday, 3rd July 2024 10:00:00 UTC
        let date = try XCTUnwrap(dateFormatter.date(from: "2024-07-03T10:00:00Z"))
        // Monday, 8th July 2024 00:00:00 UTC
        let expectedEndDate = try XCTUnwrap(dateFormatter.date(from: "2024-07-08T00:00:00Z"))

        let range = timeWindow.dateRange(containing: date, in: .gmt)

        XCTAssertEqual(range.upperBound, expectedEndDate)
    }

    func testDateRangeForWeekWhenContainingDateIsMidWeekUsingGMTPlusOneHasCorrectEndDate() throws {
        let timeWindow = RoundUpTimeWindow.week
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 60 * 60))
        // Wednesday, 3rd July 2024 00:00:00 UTC
        let date = try XCTUnwrap(dateFormatter.date(from: "2024-07-03T10:00:00Z"))
        // Monday, 8th July 2024  01:00:00 +01:00
        let expectedEndDate = try XCTUnwrap(dateFormatter.date(from: "2024-07-08T01:00:00Z"))

        let range = timeWindow.dateRange(containing: date, in: timeZone)

        XCTAssertEqual(range.upperBound, expectedEndDate)
    }

}
