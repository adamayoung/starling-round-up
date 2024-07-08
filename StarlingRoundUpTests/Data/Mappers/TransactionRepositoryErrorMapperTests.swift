//
//  TransactionRepositoryErrorMapperTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 08/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class TransactionRepositoryErrorMapperTests: XCTestCase {

    func testMapSettledTransactionsErrorToUnauthorized() {
        let error = TransactionRepositoryErrorMapper.mapSettledTransactionsError(APIClientError.unauthorized)

        XCTAssertEqual(error, .unauthorized)
    }

    func testMapSettledTransactionsErrorToForbidden() {
        let error = TransactionRepositoryErrorMapper.mapSettledTransactionsError(APIClientError.forbidden)

        XCTAssertEqual(error, .forbidden)
    }

    func testMapSettledTransactionsErrorToUnknown() {
        let error = TransactionRepositoryErrorMapper.mapSettledTransactionsError(APIClientError.badURL)

        XCTAssertEqual(error, .unknown)
    }

}
