//
//  AcountListViewControllerRenderTests.swift
//  StarlingRoundUpSnapshotTests
//
//  Created by Adam Young on 08/07/2024.
//

import SnapshotTesting
@testable import StarlingRoundUp
import XCTest

final class AcountListViewControllerRenderTests: XCTestCase {

    func testAccountsDisplayed() throws {
        let viewModel = try AccountListStubViewModel(
            accountSummaries: [
                Self.createAccountSummary(
                    id: XCTUnwrap(UUID(uuidString: "FAC6C34D-2D6D-4AA3-A275-BE0FF747AA79")),
                    name: "Account 1",
                    balance: Money(minorUnits: 1234, currency: "GBP")
                ),
                Self.createAccountSummary(
                    id: XCTUnwrap(UUID(uuidString: "4C7759C4-98FB-4370-B6D9-399A3792D461")),
                    name: "Account 2",
                    balance: Money(minorUnits: 2345, currency: "GBP")
                ),
                Self.createAccountSummary(
                    id: XCTUnwrap(UUID(uuidString: "F2A8CCE8-6830-424E-9C1C-B319D6ED1FCA")),
                    name: "Account 3",
                    balance: Money(minorUnits: 3456, currency: "GBP")
                )
            ]
        )

        let viewController = AccountListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        assertSnapshot(of: navigationController, as: .image(on: .iPhone13(.portrait)))
    }

}

extension AcountListViewControllerRenderTests {

    private static func createAccountSummary(
        id: Account.ID,
        name: String = "Test",
        balance: Money = Money(minorUnits: 0, currency: "GBP")
    ) -> AccountSummary {
        AccountSummary(
            id: id,
            name: name,
            balance: balance
        )
    }

}
