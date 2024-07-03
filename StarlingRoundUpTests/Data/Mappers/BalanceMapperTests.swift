//
//  BalanceMapperTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 02/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class BalanceMapperTests: XCTestCase {

    func testMapMinorUnits() {
        let dataModel = BalanceDataModel(minorUnits: 1234, currency: "GBP")

        let balance = BalanceMapper.map(dataModel)

        XCTAssertEqual(balance.minorUnits, 1234)
    }

    func testMapCurrency() {
        let dataModel = BalanceDataModel(minorUnits: 1234, currency: "GBP")

        let balance = BalanceMapper.map(dataModel)

        XCTAssertEqual(balance.currency, "GBP")
    }

}
