//
//  SettledTransactionsRequestTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 04/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class SettledTransactionsRequestTests: XCTestCase {

    var request: SettledTransactionsRequest!
    var accountID: UUID!
    var fromDate: Date!
    var toDate: Date!

    override func setUpWithError() throws {
        try super.setUpWithError()
        accountID = try XCTUnwrap(UUID(uuidString: "8E73BAD3-0898-4149-A639-3EC5BEA6B559"))
        let dateFormatter = ISO8601DateFormatter()
        // Monday, 1st July 2024 00:00:00 UTC
        fromDate = try XCTUnwrap(dateFormatter.date(from: "2024-07-01T00:00:00Z"))
        // Monday, 8th July 2024 00:00:00 UTC
        toDate = try XCTUnwrap(dateFormatter.date(from: "2024-07-08T00:00:00Z"))
        let dateRange = fromDate ..< toDate
        request = SettledTransactionsRequest(accountID: accountID, dateRange: dateRange)
    }

    override func tearDown() {
        request = nil
        toDate = nil
        fromDate = nil
        accountID = nil
        super.tearDown()
    }

    func testPath() {
        XCTAssertEqual(request.path, "/feed/account/\(accountID.uuidString)/settled-transactions-between")
    }

    func testQueryItems() {
        let expectedQueryItems = [
            "minTransactionTimestamp": "2024-07-01T00:00:00Z",
            "maxTransactionTimestamp": "2024-07-08T00:00:00Z"
        ]

        XCTAssertEqual(request.queryItems, expectedQueryItems)
    }

    func testMethod() {
        XCTAssertEqual(request.method, .get)
    }

}
