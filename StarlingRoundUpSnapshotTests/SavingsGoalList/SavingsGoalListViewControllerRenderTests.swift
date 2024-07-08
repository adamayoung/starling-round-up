//
//  SavingsGoalListViewControllerRenderTests.swift
//  StarlingRoundUpSnapshotTests
//
//  Created by Adam Young on 08/07/2024.
//

import SnapshotTesting
@testable import StarlingRoundUp
import XCTest

final class SavingsGoalListViewControllerRenderTests: XCTestCase {

    var accountID: UUID!

    override func setUpWithError() throws {
        try super.setUpWithError()
        accountID = try XCTUnwrap(UUID(uuidString: "BB7758D9-961B-485C-8E73-061C6039B9A0"))
    }

    override func tearDown() {
        accountID = nil
        super.tearDown()
    }

    func testNoSavingsGoalsDisplayed() {
        let viewModel = SavingsGoalListStubViewModel(accountID: accountID, savingsGoals: [])

        let viewController = SavingsGoalListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        assertSnapshot(of: navigationController, as: .image(on: .iPhone13(.portrait)))
    }

    func testSavingsGoalsDisplayed() throws {
        let savingsGoal1ID = try XCTUnwrap(UUID(uuidString: "CB69F73F-FAD6-4C03-886F-DA958D2E1549"))
        let savingsGoal2ID = try XCTUnwrap(UUID(uuidString: "0AAA5161-1E6A-4FA7-84A1-24D0C458A4E9"))
        let savingsGoal3ID = try XCTUnwrap(UUID(uuidString: "A29498DE-3B3E-44B4-9F40-B1332D480013"))
        let savingsGoals = [
            Self.createSavingsGoal(
                id: savingsGoal1ID,
                name: "Christmas Fund",
                target: Money(minorUnits: 100_000, currency: "GBP"),
                totalSaved: Money(minorUnits: 50000, currency: "GBP")
            ),
            Self.createSavingsGoal(
                id: savingsGoal2ID,
                name: "Holiday Fund",
                target: Money(minorUnits: 1_000_000, currency: "GBP"),
                totalSaved: Money(minorUnits: 23456, currency: "GBP")
            ),
            Self.createSavingsGoal(
                id: savingsGoal3ID,
                name: "Rainy Day Fund",
                target: Money(minorUnits: 200_000, currency: "GBP"),
                totalSaved: Money(minorUnits: 21000, currency: "GBP")
            )
        ]

        let viewModel = SavingsGoalListStubViewModel(accountID: accountID, savingsGoals: savingsGoals)

        let viewController = SavingsGoalListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        assertSnapshot(of: navigationController, as: .image(on: .iPhone13(.portrait)))
    }

}

extension SavingsGoalListViewControllerRenderTests {

    private static func createSavingsGoal(
        id: UUID,
        name: String = "Test",
        target: Money = Money(minorUnits: 0, currency: "GBP"),
        totalSaved: Money = Money(minorUnits: 0, currency: "GBP"),
        savedPercentage: Int = 0,
        state: SavingsGoal.State = .active
    ) -> SavingsGoal {
        SavingsGoal(
            id: id,
            name: name,
            target: target,
            totalSaved: totalSaved,
            savedPercentage: savedPercentage,
            state: state
        )
    }

}
