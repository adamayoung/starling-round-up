//
//  BalanceTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 02/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class BalanceTests: XCTestCase {

    func testFormattedValueWhenGBPCurrencyReturnsValue() {
        let balance = Balance(minorUnits: 1234, currency: "GBP")

        let formattedValue = balance.formattedValue

        XCTAssertEqual(formattedValue, "£12.34")
    }

    func testFormattedValueWhenEURCurrencyReturnsValue() {
        let balance = Balance(minorUnits: 5678, currency: "EUR")

        let formattedValue = balance.formattedValue

        XCTAssertEqual(formattedValue, "€56.78")
    }

}
