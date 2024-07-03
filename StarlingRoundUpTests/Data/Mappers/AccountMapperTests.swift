//
//  AccountMapperTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 02/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class AccountMapperTests: XCTestCase {

    func testMapID() {
        let dataModel = Self.createAccountDataModel(accountUid: "1")

        let account = AccountMapper.map(dataModel)

        XCTAssertEqual(account.id, "1")
    }

    func testMapName() {
        let dataModel = Self.createAccountDataModel(name: "Test 123")

        let account = AccountMapper.map(dataModel)

        XCTAssertEqual(account.name, "Test 123")
    }

    func testMapType() {
        let dataModel = Self.createAccountDataModel(accountType: .primary)

        let account = AccountMapper.map(dataModel)

        XCTAssertEqual(account.type, .primary)
    }

    func testMapCurrency() {
        let dataModel = Self.createAccountDataModel(currency: "GBP")

        let account = AccountMapper.map(dataModel)

        XCTAssertEqual(account.currency, "GBP")
    }

}

extension AccountMapperTests {

    private static func createAccountDataModel(
        accountUid: String = "1",
        name: String = "Test 1",
        accountType: AccountTypeDataModel = .primary,
        defaultCategory: String = "a",
        currency: String = "GBP",
        createdAt: Date = Date(timeIntervalSince1970: 0)
    ) -> AccountDataModel {
        AccountDataModel(
            accountUid: accountUid,
            name: name,
            accountType: accountType,
            defaultCategory: defaultCategory,
            currency: currency,
            createdAt: createdAt
        )
    }

}
