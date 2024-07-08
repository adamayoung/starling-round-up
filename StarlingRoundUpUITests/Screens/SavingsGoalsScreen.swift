//
//  SavingsGoalsScreen.swift
//  StarlingRoundUpUITests
//
//  Created by Adam Young on 08/07/2024.
//

import XCTest

struct SavingsGoalsScreen: Screen {

    let app: XCUIApplication

    @discardableResult
    func verifySavingsGoalsViewVisible(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTAssertTrue(savingsGoalsTable.waitForExistence(timeout: 10), file: file, line: line)
        return self
    }

    @discardableResult
    func verifySavingsGoalCellVisibile(
        withName name: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        let cell = savingsGoalCell(withName: name)
        XCTAssertTrue(cell.waitForExistence(timeout: 10), file: file, line: line)
        return self
    }

    @discardableResult
    func tapAddSavingsGoalButton(file: StaticString = #filePath, line: UInt = #line) -> AddSavingsGoalScreen {
        XCTAssertTrue(addSavingsGoalsButton.waitForExistence(timeout: 10), file: file, line: line)
        addSavingsGoalsButton.tap()
        return AddSavingsGoalScreen(app: app)
    }

}

extension SavingsGoalsScreen {

    private enum Identifier {
        static let savingsGoalsTable = "savings-goals-table"
        static let addSavingsGoalButton = "add-savings-goal-button"
    }

    private var savingsGoalsTable: XCUIElement {
        app.tables[Identifier.savingsGoalsTable].firstMatch
    }

    private func savingsGoalCell(withName name: String) -> XCUIElement {
        app.tables.cells.staticTexts[name]
    }

    private var addSavingsGoalsButton: XCUIElement {
        app.buttons[Identifier.addSavingsGoalButton]
    }

}
