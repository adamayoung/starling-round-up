//
//  AccountScreen.swift
//  StarlingRoundUpUITests
//
//  Created by Adam Young on 08/07/2024.
//

import XCTest

struct AccountScreen: Screen {

    let app: XCUIApplication

    @discardableResult
    func verifyAccountViewVisible(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTAssertTrue(accountTable.waitForExistence(timeout: 10), file: file, line: line)
        return self
    }

    @discardableResult
    func tapRoundUpButton(file: StaticString = #filePath, line: UInt = #line) -> RoundUpScreen {
        XCTAssertTrue(roundUpButton.waitForExistence(timeout: 10), file: file, line: line)
        roundUpButton.tap()
        return RoundUpScreen(app: app)
    }

    @discardableResult
    func tapSavingsGoalCell(file: StaticString = #filePath, line: UInt = #line) -> SavingsGoalsScreen {
        XCTAssertTrue(savingsGoalCell.waitForExistence(timeout: 10), file: file, line: line)
        savingsGoalCell.tap()
        return SavingsGoalsScreen(app: app)
    }

}

extension AccountScreen {

    private enum Identifier {
        static let accountTable = "account-table"
        static let roundUpButton = "round-up-button"
        static let savingsGoalCell = "savings-goal-cell"
    }

    private var accountTable: XCUIElement {
        app.tables[Identifier.accountTable].firstMatch
    }

    private var roundUpButton: XCUIElement {
        app.tables.buttons[Identifier.roundUpButton].firstMatch
    }

    private var savingsGoalCell: XCUIElement {
        app.tables.cells[Identifier.savingsGoalCell]
    }

}
