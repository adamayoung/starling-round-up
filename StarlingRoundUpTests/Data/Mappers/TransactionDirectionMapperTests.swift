//
//  TransactionDirectionMapperTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 04/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class TransactionDirectionMapperTests: XCTestCase {

    func testMapIn() {
        let dataModel = TransactionDirectionDataModel.in

        let state = TransactionDirectionMapper.map(dataModel)

        XCTAssertEqual(state, .incoming)
    }

    func testMapOut() {
        let dataModel = TransactionDirectionDataModel.out

        let state = TransactionDirectionMapper.map(dataModel)

        XCTAssertEqual(state, .outgoing)
    }

    func testMapUnknown() {
        let dataModel = TransactionDirectionDataModel.unknown

        let state = TransactionDirectionMapper.map(dataModel)

        XCTAssertEqual(state, .unknown)
    }

}
