//
//  AddSavingsGoalScreen.swift
//  StarlingRoundUpUITests
//
//  Created by Adam Young on 08/07/2024.
//

import XCTest

struct AddSavingsGoalScreen: Screen {

    let app: XCUIApplication

    @discardableResult
    func verifyAddSavingsGoalViewVisible(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTAssertTrue(addSavingsGoalTable.waitForExistence(timeout: 10), file: file, line: line)
        return self
    }

    @discardableResult
    func typeSavingsGoalName(_ name: String) -> Self {
        nameTextField.tap()
        nameTextField.typeText(name)
        return self
    }

    @discardableResult
    func typeSavingsGoalTarget(_ target: Double) -> Self {
        targetTextField.tap()
        targetTextField.typeText("\(target)")
        return self
    }

    @discardableResult
    func tapAddButton() -> SavingsGoalsScreen {
        addSavingsButton.tap()
        return SavingsGoalsScreen(app: app)
    }

    @discardableResult
    func tapCancelButton() -> SavingsGoalsScreen {
        cancelAddSavingsButton.tap()
        return SavingsGoalsScreen(app: app)
    }

}

extension AddSavingsGoalScreen {

    private enum Identifier {
        static let addSavingsGoalTable = "add-savings-goal-table"
        static let savingsGoalNameCell = "savings-goal-name-cell"
        static let savingsGoalTargetCell = "savings-goal-target-cell"
        static let formTextField = "form-text-field"
        static let formMoneyTextField = "form-money-text-field"
        static let addButton = "add-savings-goal-add-button"
        static let cancelButton = "add-savings-goal-cancel-button"
    }

    private var addSavingsGoalTable: XCUIElement {
        app.tables[Identifier.addSavingsGoalTable]
    }

    private var nameTextField: XCUIElement {
        app.tables.cells[Identifier.savingsGoalNameCell].textFields[Identifier.formTextField]
    }

    private var targetTextField: XCUIElement {
        app.tables.cells[Identifier.savingsGoalTargetCell].textFields[Identifier.formMoneyTextField]
    }

    private var addSavingsButton: XCUIElement {
        app.buttons[Identifier.addButton]
    }

    private var cancelAddSavingsButton: XCUIElement {
        app.buttons[Identifier.cancelButton]
    }

}
