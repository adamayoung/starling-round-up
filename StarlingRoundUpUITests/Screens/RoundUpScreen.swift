//
//  RoundUpScreen.swift
//  StarlingRoundUpUITests
//
//  Created by Adam Young on 08/07/2024.
//

import XCTest

struct RoundUpScreen: Screen {

    let app: XCUIApplication

    @discardableResult
    func verifyRoundUpViewVisible(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTAssertTrue(roundUpView.waitForExistence(timeout: 10), file: file, line: line)
        return self
    }

    @discardableResult
    func tapCancelButton() -> AccountScreen {
        cancelRoundUpButton.tap()
        return AccountScreen(app: app)
    }

}

extension RoundUpScreen {

    private enum Identifier {
        static let roundUpView = "round-up-view"
        static let savingsGoalButton = "round-up-choose-savings-goal-button"
        static let canceButton = "round-up-cancel-button"
    }

    private var roundUpView: XCUIElement {
        app.otherElements[Identifier.roundUpView]
    }

    private var savingsGoalButton: XCUIElement {
        app.buttons[Identifier.savingsGoalButton]
    }

    private var cancelRoundUpButton: XCUIElement {
        app.buttons[Identifier.canceButton]
    }

}
