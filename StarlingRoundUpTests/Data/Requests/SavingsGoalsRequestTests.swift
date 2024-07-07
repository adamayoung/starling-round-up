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
    var accountID: UUID!

    override func setUpWithError() throws {
        try super.setUpWithError()
        accountID = try XCTUnwrap(UUID(uuidString: "D385228E-8140-4091-915E-D0C3B81097A1"))
        request = SavingsGoalsRequest(accountID: accountID)
    }

    override func tearDown() {
        request = nil
        super.tearDown()
    }

    func testPath() {
        XCTAssertEqual(request.path, "/account/\(accountID.uuidString)/savings-goals")
    }

    func testMethod() {
        XCTAssertEqual(request.method, .get)
    }

}
