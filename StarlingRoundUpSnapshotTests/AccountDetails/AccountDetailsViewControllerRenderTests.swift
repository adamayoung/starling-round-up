//
//  AccountDetailsViewControllerRenderTests.swift
//  StarlingRoundUpSnapshotTests
//
//  Created by Adam Young on 08/07/2024.
//

import SnapshotTesting
@testable import StarlingRoundUp
import XCTest

final class AccountDetailsViewControllerRenderTests: XCTestCase {

    var accountID: UUID!

    override func setUpWithError() throws {
        try super.setUpWithError()
        accountID = try XCTUnwrap(UUID(uuidString: "C13F6ACC-4D3D-4931-A3B4-DB26FC7D738A"))
    }

    override func tearDown() {
        accountID = nil
        super.tearDown()
    }

    func testAccountDetailsDisplayed() throws {
        let viewModel = AccountDetailsStubViewModel(
            accountID: accountID,
            accountSummary: AccountSummary(
                account: Account(id: accountID, name: "Account 1", type: .primary, currency: "GBP"),
                balance: Money(minorUnits: 12345, currency: "GBP")
            )
        )

        let viewController = AccountDetailsViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        assertSnapshot(of: navigationController, as: .image(on: .iPhone13(.portrait)))
    }

}
