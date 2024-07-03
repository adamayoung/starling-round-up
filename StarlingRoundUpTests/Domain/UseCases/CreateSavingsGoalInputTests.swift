//
//  CreateSavingsGoalInputTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class CreateSavingsGoalInputTests: XCTestCase {

    func testValidateWithInvalidNameThrowsInvalidNameError() {
        let input = Self.createSavingsGoalInput(name: "")

        XCTAssertThrowsError(try input.validate()) { error in
            XCTAssertEqual(error as? CreateSavingsGoalError, .invalidName)
        }
    }

    func testValidateWithInvalidCurrencyThrowsInvalidCurrenyError() {
        let input = Self.createSavingsGoalInput(currency: "")

        XCTAssertThrowsError(try input.validate()) { error in
            XCTAssertEqual(error as? CreateSavingsGoalError, .invalidCurrency)
        }
    }

    func testValidateWithInvalidTargetThrowsInvalidTargetError() {
        let input = Self.createSavingsGoalInput(targetMinorUnits: -1)

        XCTAssertThrowsError(try input.validate()) { error in
            XCTAssertEqual(error as? CreateSavingsGoalError, .invalidTarget)
        }
    }

}

extension CreateSavingsGoalInputTests {

    private static func createSavingsGoalInput(
        name: String = "Test 1",
        currency: String = "GBP",
        targetMinorUnits: Int = 100
    ) -> SavingsGoalInput {
        SavingsGoalInput(
            name: name,
            currency: currency,
            targetMinorUnits: targetMinorUnits
        )
    }

}
