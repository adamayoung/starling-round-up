//
//  MoneyTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 02/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class MoneyTests: XCTestCase {

    func testFormattedWhenGBPCurrencyReturnsValue() {
        let balance = Money(minorUnits: 1234, currency: "GBP")

        let formattedValue = balance.formatted()

        XCTAssertEqual(formattedValue, "£12.34")
    }

    func testFormattedWhenEURCurrencyReturnsValue() {
        let balance = Money(minorUnits: 5678, currency: "EUR")

        let formattedValue = balance.formatted()

        XCTAssertEqual(formattedValue, "€56.78")
    }

}
