//
//  SavingsGoalsRequestTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class SavingsGoalsRequestTests: XCTestCase {

    func testPath() {
        let request = SavingsGoalsRequest(accountID: "123")

        XCTAssertEqual(request.path, "/accounts/123/savings-goals")
    }

    func testMethod() {
        let request = SavingsGoalsRequest(accountID: "123")

        XCTAssertEqual(request.method, .get)
    }

}
