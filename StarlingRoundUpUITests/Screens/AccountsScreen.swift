//
//  AccountsScreen.swift
//  StarlingRoundUpUITests
//
//  Created by Adam Young on 08/07/2024.
//

import XCTest

struct AccountsScreen: Screen {

    let app: XCUIApplication

    @discardableResult
    func verifyAccountsViewVisible(file: StaticString = #filePath, line: UInt = #line) -> Self {
        let table = accountListTable
        XCTAssertTrue(table.waitForExistence(timeout: 10), file: file, line: line)
        return self
    }

    @discardableResult
    func verifyAccountsVisible(file: StaticString = #filePath, line: UInt = #line) -> Self {
        let table = accountListTable
        XCTAssertTrue(table.waitForExistence(timeout: 10), file: file, line: line)
        XCTAssertGreaterThan(table.cells.count, 0, file: file, line: line)
        return self
    }

    @discardableResult
    func tapFirstAccountCell(file: StaticString = #filePath, line: UInt = #line) -> AccountScreen {
        let cell = firstAccountCell
        XCTAssertTrue(cell.waitForExistence(timeout: 10), file: file, line: line)
        cell.tap()
        return AccountScreen(app: app)
    }

    @discardableResult
    func tapAccountCell(withID accountID: UUID, file: StaticString = #filePath, line: UInt = #line) -> AccountScreen {
        let cell = accountCell(withAccountID: accountID)
        XCTAssertTrue(cell.waitForExistence(timeout: 10), file: file, line: line)
        cell.tap()
        return AccountScreen(app: app)
    }

    @discardableResult
    func verifyAccountCellVisible(accountID: UUID, file: StaticString = #filePath, line: UInt = #line) -> Self {
        let cell = accountCell(withAccountID: accountID)
        XCTAssertTrue(cell.waitForExistence(timeout: 10), file: file, line: line)
        return self
    }

}

extension AccountsScreen {

    private enum Identifier {
        static let accountsTable = "accounts-table"
        static func cell(withAccountID accountID: UUID) -> String {
            "account-cell-\(accountID)"
        }
    }

    private var accountListTable: XCUIElement {
        app.tables[Identifier.accountsTable].firstMatch
    }

    private var firstAccountCell: XCUIElement {
        accountListTable.cells.firstMatch
    }

    private func accountCell(withAccountID accountID: UUID) -> XCUIElement {
        let identifier = Identifier.cell(withAccountID: accountID)
        return accountListTable.cells[identifier].firstMatch
    }

}
