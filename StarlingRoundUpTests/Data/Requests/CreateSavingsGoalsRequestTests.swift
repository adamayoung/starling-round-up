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
    var accountID: UUID!

    override func setUpWithError() throws {
        try super.setUpWithError()
        accountID = try XCTUnwrap(UUID(uuidString: "7AEA4E58-6137-4F92-B2A2-37A2C631F731"))
        request = CreateSavingsGoalsRequest(
            accountID: accountID,
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
        XCTAssertEqual(request.path, "/account/\(accountID.uuidString)/savings-goals")
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
