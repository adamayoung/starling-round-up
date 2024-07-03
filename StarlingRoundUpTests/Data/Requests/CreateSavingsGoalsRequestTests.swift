//
//  CreateSavingsGoalsRequestTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class CreateSavingsGoalsRequestTests: XCTestCase {

    var request: CreateSavingsGoalsRequest!

    override func setUp() {
        super.setUp()
        request = CreateSavingsGoalsRequest(
            accountID: "1",
            name: "SG 1",
            currency: "GBP",
            targetMinorUnits: 100
        )
    }

    override func tearDown() {
        request = nil
        super.tearDown()
    }

    func testPath() {
        XCTAssertEqual(request.path, "/account/1/savings-goals")
    }

    func testMethod() {
        XCTAssertEqual(request.method, .put)
    }

    func testBody() {
        let expectedBody = CreateSavingsGoalsRequest.Body(
            name: "SG 1",
            currency: "GBP",
            target: CreateSavingsGoalsRequest.Body.Target(
                minorUnits: 100,
                currency: "GBP"
            )
        )

        XCTAssertEqual(request.body, expectedBody)
    }

}
