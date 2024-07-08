//
//  AccountTest.swift
//  StarlingRoundUpUITests
//
//  Created by Adam Young on 08/07/2024.
//

import XCTest

final class AccountTests: UITestCaseBase {

    var accountScreen: AccountScreen!

    override func setUp() {
        super.setUp()
        accountScreen = initialScreen
            .tapFirstAccountCell()
            .verifyAccountViewVisible()
    }

    override func tearDown() {
        accountScreen = nil
        super.tearDown()
    }

    func testNavigateToRoundUp() {
        accountScreen
            .tapRoundUpButton()
            .verifyRoundUpViewVisible()
    }

    func testNavigateToSavingsGoals() {
        accountScreen
            .tapSavingsGoalCell()
            .verifySavingsGoalsViewVisible()
    }

}
