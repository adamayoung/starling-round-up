//
//  AccountMapperTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 02/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class AccountMapperTests: XCTestCase {

    func testMapID() throws {
        let accountID = try XCTUnwrap(UUID(uuidString: "78677CA0-E4F0-4F70-8807-D1B38C849FD1"))
        let dataModel = Self.createAccountDataModel(accountUid: accountID)

        let account = AccountMapper.map(dataModel)

        XCTAssertEqual(account.id, accountID)
    }

    func testMapName() throws {
        let accountID = try XCTUnwrap(UUID(uuidString: "78677CA0-E4F0-4F70-8807-D1B38C849FD1"))
        let dataModel = Self.createAccountDataModel(accountUid: accountID, name: "Test 123")

        let account = AccountMapper.map(dataModel)

        XCTAssertEqual(account.name, "Test 123")
    }

    func testMapType() throws {
        let accountID = try XCTUnwrap(UUID(uuidString: "78677CA0-E4F0-4F70-8807-D1B38C849FD1"))
        let dataModel = Self.createAccountDataModel(accountUid: accountID, accountType: .primary)

        let account = AccountMapper.map(dataModel)

        XCTAssertEqual(account.type, .primary)
    }

    func testMapCurrency() throws {
        let accountID = try XCTUnwrap(UUID(uuidString: "78677CA0-E4F0-4F70-8807-D1B38C849FD1"))
        let dataModel = Self.createAccountDataModel(accountUid: accountID, currency: "GBP")

        let account = AccountMapper.map(dataModel)

        XCTAssertEqual(account.currency, "GBP")
    }

}

extension AccountMapperTests {

    private static func createAccountDataModel(
        accountUid: UUID,
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
