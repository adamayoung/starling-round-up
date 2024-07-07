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
        dateFormatter = nil
        super.tearDown()
    }

    func testDateRangeForWeekWhenContainingDateIsMidWeekUsingGMTHasCorrectStartDate() throws {
        let timeWindow = RoundUpTimeWindow.week
        let date = try XCTUnwrap(dateFormatter.date(from: "2024-07-03T10:00:00Z"))
        let expectedStartDate = try XCTUnwrap(dateFormatter.date(from: "2024-07-01T00:00:00Z"))

        let range = timeWindow.dateRange(containing: date, in: .gmt)

        XCTAssertEqual(range.lowerBound, expectedStartDate)
    }

    func testDateRangeForWeekWhenContainingDateIsMidWeekUsingGMTPlusOneHasCorrectStartDate() throws {
        let timeWindow = RoundUpTimeWindow.week
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 60 * 60))
        let date = try XCTUnwrap(dateFormatter.date(from: "2024-07-03T10:00:00Z"))
        let expectedStartDate = try XCTUnwrap(dateFormatter.date(from: "2024-07-01T01:00:00Z"))

        let range = timeWindow.dateRange(containing: date, in: timeZone)

        XCTAssertEqual(range.lowerBound, expectedStartDate)
    }

    func testDateRangeForWeekWhenContainingDateIsMidWeekUsingGMTHasCorrectEndDate() throws {
        let timeWindow = RoundUpTimeWindow.week
        let date = try XCTUnwrap(dateFormatter.date(from: "2024-07-03T10:00:00Z"))
        let expectedEndDate = try XCTUnwrap(dateFormatter.date(from: "2024-07-08T00:00:00Z"))

        let range = timeWindow.dateRange(containing: date, in: .gmt)

        XCTAssertEqual(range.upperBound, expectedEndDate)
    }

    func testDateRangeForWeekWhenContainingDateIsMidWeekUsingGMTPlusOneHasCorrectEndDate() throws {
        let timeWindow = RoundUpTimeWindow.week
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 60 * 60))
        let date = try XCTUnwrap(dateFormatter.date(from: "2024-07-03T10:00:00Z"))
        let expectedEndDate = try XCTUnwrap(dateFormatter.date(from: "2024-07-08T01:00:00Z"))

        let range = timeWindow.dateRange(containing: date, in: timeZone)

        XCTAssertEqual(range.upperBound, expectedEndDate)
    }

    func testStartDateOfPreviousTimeWindowForWeekRetunsPreviousWeekStartDate() throws {
        let timeWindow = RoundUpTimeWindow.week
        let timeZone = TimeZone.gmt
        let date = try XCTUnwrap(dateFormatter.date(from: "2024-07-08T00:00:00Z"))
        let expectedPreviousDate = try XCTUnwrap(dateFormatter.date(from: "2024-07-01T00:00:00Z"))

        let previousDate = timeWindow.startDateOfPreviousTimeWindow(date: date, in: timeZone)

        XCTAssertEqual(previousDate, expectedPreviousDate)
    }

    func testStartDateOfPreviousTimeWindowForWeekWhenGMTPlusOneRetunsPreviousWeekStartDate() throws {
        let timeWindow = RoundUpTimeWindow.week
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 60 * 60))
        let date = try XCTUnwrap(dateFormatter.date(from: "2024-07-08T01:00:00Z"))
        let expectedPreviousDate = try XCTUnwrap(dateFormatter.date(from: "2024-07-01T01:00:00Z"))

        let previousDate = timeWindow.startDateOfPreviousTimeWindow(date: date, in: timeZone)

        XCTAssertEqual(previousDate, expectedPreviousDate)
    }

    func testStartDateOfNextTimeWindowForWeekRetunsNextWeekStartDate() throws {
        let timeWindow = RoundUpTimeWindow.week
        let timeZone = TimeZone.gmt
        let date = try XCTUnwrap(dateFormatter.date(from: "2024-07-01T00:00:00Z"))
        let expectedNextDate = try XCTUnwrap(dateFormatter.date(from: "2024-07-08T00:00:00Z"))

        let nextDate = timeWindow.startDateOfNextTimeWindow(date: date, in: timeZone)

        XCTAssertEqual(nextDate, expectedNextDate)
    }

    func testStartDateOfNextTimeWindowForWeekWhenGMTPlusOneRetunsNextWeekStartDate() throws {
        let timeWindow = RoundUpTimeWindow.week
        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 60 * 60))
        let date = try XCTUnwrap(dateFormatter.date(from: "2024-07-01T01:00:00Z"))
        let expectedNextDate = try XCTUnwrap(dateFormatter.date(from: "2024-07-08T01:00:00Z"))

        let nextDate = timeWindow.startDateOfNextTimeWindow(date: date, in: timeZone)

        XCTAssertEqual(nextDate, expectedNextDate)
    }

}
