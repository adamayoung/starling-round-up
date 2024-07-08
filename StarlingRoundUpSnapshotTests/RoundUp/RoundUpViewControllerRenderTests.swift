//
//  RoundUpViewControllerRenderTests.swift
//  StarlingRoundUpSnapshotTests
//
//  Created by Adam Young on 08/07/2024.
//

import SnapshotTesting
@testable import StarlingRoundUp
import XCTest

final class RoundUpViewControllerRenderTests: XCTestCase {

    var accountID: UUID!

    override func setUpWithError() throws {
        try super.setUpWithError()
        accountID = try XCTUnwrap(UUID(uuidString: "F2F853A9-E94B-47DD-B8D0-0449D7DF3125"))
    }

    override func tearDown() {
        accountID = nil
        super.tearDown()
    }

    func testZeroRoundUpNoSavingsGoalSelectedDisplayed() {
        let roundUpSummary = Self.createRoundUpSummary(accountID: accountID)
        let viewModel = RoundUpStubViewModel(
            accountID: accountID,
            roundUpSummary: roundUpSummary,
            selectedSavingsGoal: nil
        )

        let viewController = RoundUpViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        assertSnapshot(of: navigationController, as: .image(on: .iPhone13(.portrait)))
    }

    func testZeroRoundUpWithSelectedSavingsGoalDisplayed() throws {
        let roundUpSummary = Self.createRoundUpSummary(accountID: accountID)
        let savingsGoalID = try XCTUnwrap(UUID(uuidString: "D3E03FC1-7368-4BE6-9CF7-49E6B8B13B6D"))
        let selectedSavingsGoal = Self.createSavingsGoal(id: savingsGoalID, name: "Holiday Fund")

        let viewModel = RoundUpStubViewModel(
            accountID: accountID,
            roundUpSummary: roundUpSummary,
            selectedSavingsGoal: selectedSavingsGoal
        )

        let viewController = RoundUpViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        assertSnapshot(of: navigationController, as: .image(on: .iPhone13(.portrait)))
    }

    func testRoundUpWithSelectedSavingsGoalWithInsufficientFundsDisplayed() throws {
        let roundUpSummary = Self.createRoundUpSummary(
            accountID: accountID,
            amount: Money(minorUnits: 1234, currency: "GBP"),
            accountBalance: Money(minorUnits: 1, currency: "GBP")
        )
        let savingsGoalID = try XCTUnwrap(UUID(uuidString: "D3E03FC1-7368-4BE6-9CF7-49E6B8B13B6D"))
        let selectedSavingsGoal = Self.createSavingsGoal(id: savingsGoalID, name: "Holiday Fund")

        let viewModel = RoundUpStubViewModel(
            accountID: accountID,
            roundUpSummary: roundUpSummary,
            selectedSavingsGoal: selectedSavingsGoal
        )

        let viewController = RoundUpViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        assertSnapshot(of: navigationController, as: .image(on: .iPhone13(.portrait)))
    }

    func testRoundUpWithSelectedSavingsGoalWithSufficientFundsDisplayed() throws {
        let roundUpSummary = Self.createRoundUpSummary(
            accountID: accountID,
            amount: Money(minorUnits: 1234, currency: "GBP"),
            accountBalance: Money(minorUnits: 10000, currency: "GBP")
        )
        let savingsGoalID = try XCTUnwrap(UUID(uuidString: "D3E03FC1-7368-4BE6-9CF7-49E6B8B13B6D"))
        let selectedSavingsGoal = Self.createSavingsGoal(id: savingsGoalID, name: "Holiday Fund")

        let viewModel = RoundUpStubViewModel(
            accountID: accountID,
            roundUpSummary: roundUpSummary,
            selectedSavingsGoal: selectedSavingsGoal
        )

        let viewController = RoundUpViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        assertSnapshot(of: navigationController, as: .image(on: .iPhone13(.portrait)))
    }

}

extension RoundUpViewControllerRenderTests {

    private static func createRoundUpSummary(
        accountID: Account.ID,
        amount: Money = Money(minorUnits: 0, currency: "GBP"),
        dateRange: Range<Date> = Date(timeIntervalSince1970: 100_000) ..< Date(timeIntervalSince1970: 150_000),
        timeWindow: RoundUpTimeWindow = .week,
        accountBalance: Money = Money(minorUnits: 1, currency: "GBP"),
        availableSavingsGoals: [SavingsGoal] = []
    ) -> RoundUpSummary {
        RoundUpSummary(
            accountID: accountID,
            amount: amount,
            dateRange: dateRange,
            timeWindow: timeWindow,
            accountBalance: accountBalance,
            availableSavingsGoals: availableSavingsGoals
        )
    }

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
