//
//  BalanceRequestTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 02/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class BalanceRequestTests: XCTestCase {

    func testPath() {
        let request = BalanceRequest(accountID: "123")

        XCTAssertEqual(request.path, "/accounts/123/balance")
    }

    func testMethod() {
        let request = BalanceRequest(accountID: "123")

        XCTAssertEqual(request.method, .get)
    }

}
