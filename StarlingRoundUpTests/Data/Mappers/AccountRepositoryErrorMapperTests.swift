//
//  AccountRepositoryErrorMapperTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 08/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class AccountRepositoryErrorMapperTests: XCTestCase {

    func testMapAccountsErrorToUnauthorized() {
        let error = AccountRepositoryErrorMapper.mapAccountsError(APIClientError.unauthorized)

        XCTAssertEqual(error, .unauthorized)
    }

    func testMapAccountsErrorToForbidden() {
        let error = AccountRepositoryErrorMapper.mapAccountsError(APIClientError.forbidden)

        XCTAssertEqual(error, .forbidden)
    }

    func testMapAccountsErrorToUnknown() {
        let error = AccountRepositoryErrorMapper.mapAccountsError(APIClientError.badURL)

        XCTAssertEqual(error, .unknown)
    }

    func testMapBalanceErrorToUnauthorized() {
        let error = AccountRepositoryErrorMapper.mapBalanceError(APIClientError.unauthorized)

        XCTAssertEqual(error, .unauthorized)
    }

    func testMapBalanceErrorToForbidden() {
        let error = AccountRepositoryErrorMapper.mapBalanceError(APIClientError.forbidden)

        XCTAssertEqual(error, .forbidden)
    }

    func testMapBalanceErrorToUnknown() {
        let error = AccountRepositoryErrorMapper.mapBalanceError(APIClientError.badURL)

        XCTAssertEqual(error, .unknown)
    }

}
