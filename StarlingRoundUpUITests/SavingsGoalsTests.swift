//
//  SavingsGoalsTests.swift
//  StarlingRoundUpUITests
//
//  Created by Adam Young on 08/07/2024.
//

import XCTest

final class SavingsGoalsTests: UITestCaseBase {

    var savingsGoalsScreen: SavingsGoalsScreen!

    override func setUp() {
        super.setUp()
        savingsGoalsScreen = initialScreen
            .tapFirstAccountCell()
            .tapSavingsGoalCell()
            .verifySavingsGoalsViewVisible()
    }

    override func tearDown() {
        savingsGoalsScreen = nil
        super.tearDown()
    }

    func testNavigateToAddSavingsGoal() {
        savingsGoalsScreen
            .tapAddSavingsGoalButton()
            .verifyAddSavingsGoalViewVisible()
    }

}
