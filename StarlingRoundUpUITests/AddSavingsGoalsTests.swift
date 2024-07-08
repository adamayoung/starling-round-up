//
//  AddSavingsGoalsTests.swift
//  StarlingRoundUpUITests
//
//  Created by Adam Young on 08/07/2024.
//

import XCTest

final class AddSavingsGoalsTests: UITestCaseBase {

    var addSavingsGoalScreen: AddSavingsGoalScreen!

    override func setUp() {
        super.setUp()
        addSavingsGoalScreen = initialScreen
            .tapFirstAccountCell()
            .tapSavingsGoalCell()
            .tapAddSavingsGoalButton()
            .verifyAddSavingsGoalViewVisible()
    }

    override func tearDown() {
        addSavingsGoalScreen = nil
        super.tearDown()
    }

    func testAddSavingsGoal() {
        let savingsGoalName = "Test \(UUID().uuidString)"
        let savingsGoalTarget = 12.34

        addSavingsGoalScreen
            .typeSavingsGoalName(savingsGoalName)
            .typeSavingsGoalTarget(savingsGoalTarget)
            .tapAddButton()
            .verifySavingsGoalsViewVisible()
            .verifySavingsGoalCellVisibile(withName: savingsGoalName)
    }

    func testCancelAddingSavingsGoal() {
        addSavingsGoalScreen
            .tapCancelButton()
            .verifySavingsGoalsViewVisible()
    }

}
