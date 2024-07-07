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
    var accountID: Account.ID!

    override func setUpWithError() throws {
        try super.setUpWithError()
        accountID = try XCTUnwrap(UUID(uuidString: "D385228E-8140-4091-915E-D0C3B81097A1"))
        request = BalanceRequest(accountID: accountID)
    }

    override func tearDown() {
        request = nil
        accountID = nil
        super.tearDown()
    }

    func testPath() {
        XCTAssertEqual(request.path, "/accounts/\(accountID.uuidString)/balance")
    }

    func testMethod() {
        XCTAssertEqual(request.method, .get)
    }

}
