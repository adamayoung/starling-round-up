//
//  AddSavingsGoalViewControllerRenderTests.swift
//  StarlingRoundUpSnapshotTests
//
//  Created by Adam Young on 08/07/2024.
//

import SnapshotTesting
@testable import StarlingRoundUp
import XCTest

final class AddSavingsGoalViewControllerRenderTests: XCTestCase {

    var accountID: UUID!

    override func setUpWithError() throws {
        try super.setUpWithError()
        accountID = try XCTUnwrap(UUID(uuidString: "BB7758D9-961B-485C-8E73-061C6039B9A0"))
    }

    override func tearDown() {
        accountID = nil
        super.tearDown()
    }

    func testEmptyFormDisplayed() {
        let viewModel = AddSavingsGoalStubViewModel(accountID: accountID, currency: "GBP", isFormValid: false)

        let viewController = AddSavingsGoalViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        assertSnapshot(of: navigationController, as: .image(on: .iPhone13(.portrait)))
    }

    func testFormWithNameAndTargetDisplayed() {
        let viewModel = AddSavingsGoalStubViewModel(
            accountID: accountID,
            currency: "GBP",
            savingsGoalName: "Holiday Fund",
            savingsGoalTarget: 1000,
            isFormValid: true
        )

        let viewController = AddSavingsGoalViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        assertSnapshot(of: navigationController, as: .image(on: .iPhone13(.portrait)))
    }

}
