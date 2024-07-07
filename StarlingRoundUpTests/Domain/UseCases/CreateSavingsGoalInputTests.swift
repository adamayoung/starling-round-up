//
//  CreateSavingsGoalInputTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class CreateSavingsGoalInputTests: XCTestCase {

    func testValidateWithInvalidNameThrowsInvalidNameError() throws {
        let accountID = try XCTUnwrap(UUID(uuidString: "F6F321B7-BE76-435F-957B-52F7E61E41BE"))
        let input = Self.createSavingsGoalInput(accountID: accountID, name: "")

        XCTAssertThrowsError(try input.validate()) { error in
            XCTAssertEqual(error as? CreateSavingsGoalError, .invalidName)
        }
    }

    func testValidateWithInvalidCurrencyThrowsInvalidCurrenyError() throws {
        let accountID = try XCTUnwrap(UUID(uuidString: "F6F321B7-BE76-435F-957B-52F7E61E41BE"))
        let input = Self.createSavingsGoalInput(accountID: accountID, currency: "")

        XCTAssertThrowsError(try input.validate()) { error in
            XCTAssertEqual(error as? CreateSavingsGoalError, .invalidCurrency)
        }
    }

    func testValidateWithInvalidTargetThrowsInvalidTargetError() throws {
        let accountID = try XCTUnwrap(UUID(uuidString: "F6F321B7-BE76-435F-957B-52F7E61E41BE"))
        let input = Self.createSavingsGoalInput(accountID: accountID, targetMinorUnits: -1)

        XCTAssertThrowsError(try input.validate()) { error in
            XCTAssertEqual(error as? CreateSavingsGoalError, .invalidTarget)
        }
    }

}

extension CreateSavingsGoalInputTests {

    private static func createSavingsGoalInput(
        accountID: UUID,
        name: String = "Test 1",
        currency: String = "GBP",
        targetMinorUnits: Int = 100
    ) -> SavingsGoalInput {
        SavingsGoalInput(
            accountID: accountID,
            name: name,
            currency: currency,
            targetMinorUnits: targetMinorUnits
        )
    }

}
