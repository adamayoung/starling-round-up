//
//  AccountsRequestTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 02/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class AccountsRequestTests: XCTestCase {

    func testPath() {
        let request = AccountsRequest()

        XCTAssertEqual(request.path, "/accounts")
    }

    func testMethod() {
        let request = AccountsRequest()

        XCTAssertEqual(request.method, .get)
    }

}
