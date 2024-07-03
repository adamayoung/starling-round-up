//
//  AccountAPIRepositoryTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 02/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class AccountAPIRepositoryTests: XCTestCase {

    var repository: AccountAPIRepository!
    var apiClient: APIStubClient!

    override func setUp() {
        super.setUp()
        apiClient = APIStubClient()
        repository = AccountAPIRepository(apiClient: apiClient)
    }

    override func tearDown() {
        repository = nil
        apiClient = nil
        super.tearDown()
    }

    func testAccountsMakeCorrectAPIRequest() async throws {
        let expectedAPIRequest = AccountsRequest()

        _ = try? await repository.accounts()

        XCTAssertEqual(apiClient.lastRequest as? AccountsRequest, expectedAPIRequest)
    }

    func testAccountsReturnsAccounts() async throws {
        let accountDataModels = [
            AccountDataModel(
                accountUid: "1",
                name: "Test 1",
                accountType: .primary,
                defaultCategory: "a",
                currency: "GBP",
                createdAt: Date(timeIntervalSince1970: 0)
            ),
            AccountDataModel(
                accountUid: "2",
                name: "Test 2",
                accountType: .primary,
                defaultCategory: "b",
                currency: "GBP",
                createdAt: Date(timeIntervalSince1970: 10)
            )
        ]
        let responseDataModel = AccountsResponseDataModel(accounts: accountDataModels)
        apiClient.responseResult = .success(responseDataModel)

        let accounts = try await repository.accounts()

        XCTAssertEqual(accounts.count, 2)
        XCTAssertEqual(accounts[0].id, "1")
        XCTAssertEqual(accounts[1].id, "2")
    }

    func testBalanceMakesCorrectAPIRequest() async throws {
        let accountID = "1"
        let expectedAPIRequest = BalanceRequest(accountID: accountID)

        _ = try? await repository.balance(for: accountID)

        XCTAssertEqual(apiClient.lastRequest as? BalanceRequest, expectedAPIRequest)
    }

    func testBalanceReturnsBalance() async throws {
        let balanceDataModel = MoneyDataModel(minorUnits: 1234, currency: "GBP")
        let responseDataModel = BalanceResponseDataModel(amount: balanceDataModel)
        apiClient.responseResult = .success(responseDataModel)

        let balance = try await repository.balance(for: "1")

        XCTAssertEqual(balance?.minorUnits, 1234)
        XCTAssertEqual(balance?.currency, "GBP")
    }

}
