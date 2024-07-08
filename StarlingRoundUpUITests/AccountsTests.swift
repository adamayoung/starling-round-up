//
//  AccountsTests.swift
//  StarlingRoundUpUITests
//
//  Created by Adam Young on 02/07/2024.
//

import XCTest

final class AccountsTests: UITestCaseBase {

    var accountsScreen: AccountsScreen!

    override func setUp() {
        super.setUp()
        accountsScreen = initialScreen.verifyAccountsVisible()
    }

    override func tearDown() {
        accountsScreen = nil
        super.tearDown()
    }

    func testNavigateToAccountViewFromPrimaryAccount() {
        initialScreen
            .tapFirstAccountCell()
            .verifyAccountViewVisible()
    }

}
