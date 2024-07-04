//
//  AccountsRequestTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 02/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class AccountsRequestTests: XCTestCase {

    var request: AccountsRequest!

    override func setUp() {
        super.setUp()
        request = AccountsRequest()
    }

    override func tearDown() {
        request = nil
        super.tearDown()
    }

    func testPath() {
        XCTAssertEqual(request.path, "/accounts")
    }

    func testMethod() {
        XCTAssertEqual(request.method, .get)
    }

}
