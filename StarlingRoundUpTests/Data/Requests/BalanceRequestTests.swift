//
//  BalanceRequestTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 02/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class BalanceRequestTests: XCTestCase {

    var request: BalanceRequest!

    override func setUp() {
        super.setUp()
        request = BalanceRequest(accountID: "123")
    }

    override func tearDown() {
        request = nil
        super.tearDown()
    }

    func testPath() {
        XCTAssertEqual(request.path, "/accounts/123/balance")
    }

    func testMethod() {
        XCTAssertEqual(request.method, .get)
    }

}
