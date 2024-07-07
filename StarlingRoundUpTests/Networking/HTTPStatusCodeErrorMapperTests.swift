//
//  HTTPStatusCodeErrorMapperTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 07/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class HTTPStatusCodeErrorMapperTests: XCTestCase {

    func testOK() {
        XCTAssertNil(HTTPStatusCodeErrorMapper.map(200))
    }

    func testBadRequest() {
        let error = HTTPStatusCodeErrorMapper.map(400)

        XCTAssertEqual(error, .badRequest(nil))
    }

    func testUnauthorized() {
        let error = HTTPStatusCodeErrorMapper.map(401)

        XCTAssertEqual(error, .unauthorized)
    }

    func testForbidden() {
        let error = HTTPStatusCodeErrorMapper.map(403)

        XCTAssertEqual(error, .forbidden)
    }

    func testNotFound() {
        let error = HTTPStatusCodeErrorMapper.map(404)

        XCTAssertEqual(error, .notFound)
    }

    func testUnknownClientError() {
        let error = HTTPStatusCodeErrorMapper.map(450)

        XCTAssertEqual(error, .unknownClientError)
    }

    func testServerError() {
        let error = HTTPStatusCodeErrorMapper.map(500)

        XCTAssertEqual(error, .serverError)
    }

    func testUnknown() {
        let error = HTTPStatusCodeErrorMapper.map(600)

        XCTAssertEqual(error, .unknown)
    }

}
