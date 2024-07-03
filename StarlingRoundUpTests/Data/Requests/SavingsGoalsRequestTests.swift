//
//  SavingsGoalsRequestTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class SavingsGoalsRequestTests: XCTestCase {

    var request: SavingsGoalsRequest!

    override func setUp() {
        super.setUp()
        request = SavingsGoalsRequest(accountID: "123")
    }

    override func tearDown() {
        request = nil
        super.tearDown()
    }

    func testPath() {
        XCTAssertEqual(request.path, "/account/123/savings-goals")
    }

    func testMethod() {
        XCTAssertEqual(request.method, .get)
    }

}
