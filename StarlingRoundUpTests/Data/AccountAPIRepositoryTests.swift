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

    func testAccountsMakesCorrectAPIRequest() async throws {
        let expectedAPIRequest = AccountsRequest()

        _ = try? await repository.accounts()

        XCTAssertEqual(apiClient.lastRequest as? AccountsRequest, expectedAPIRequest)
    }

    func testAccountsReturnsAccounts() async throws {
        let account1ID = try XCTUnwrap(UUID(uuidString: "0F3AD922-5BDD-4930-A10D-EB9AFB0C036D"))
        let account2ID = try XCTUnwrap(UUID(uuidString: "448D0193-5446-4AF4-809A-3C20FB63EF04"))
        let accountDataModels = [
            AccountDataModel(
                accountUid: account1ID,
                name: "Test 1",
                accountType: .primary,
                defaultCategory: "a",
                currency: "GBP",
                createdAt: Date(timeIntervalSince1970: 0)
            ),
            AccountDataModel(
                accountUid: account2ID,
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
        XCTAssertEqual(accounts.map(\.id), [account1ID, account2ID])
    }

    func testBalanceMakesCorrectAPIRequest() async throws {
        let accountID = try XCTUnwrap(UUID(uuidString: "58EDCA32-0050-43B6-82DD-588E0A0D707B"))
        let expectedAPIRequest = BalanceRequest(accountID: accountID)

        _ = try? await repository.balance(for: accountID)

        XCTAssertEqual(apiClient.lastRequest as? BalanceRequest, expectedAPIRequest)
    }

    func testBalanceReturnsBalance() async throws {
        let accountID = try XCTUnwrap(UUID(uuidString: "58EDCA32-0050-43B6-82DD-588E0A0D707B"))
        let balanceDataModel = MoneyDataModel(minorUnits: 1234, currency: "GBP")
        let responseDataModel = BalanceResponseDataModel(amount: balanceDataModel)
        apiClient.responseResult = .success(responseDataModel)

        let balance = try await repository.balance(for: accountID)

        XCTAssertEqual(balance.minorUnits, 1234)
        XCTAssertEqual(balance.currency, "GBP")
    }

}
