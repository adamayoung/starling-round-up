//
//  FetchAccountSummariesTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 02/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class FetchAccountSummariesTests: XCTestCase {

    var useCase: FetchAccountSummaries!
    var accountRepository: AccountStubRepository!
    var accountID: Account.ID!

    override func setUpWithError() throws {
        try super.setUpWithError()
        accountRepository = AccountStubRepository()
        useCase = FetchAccountSummaries(accountRepository: accountRepository)
        accountID = try XCTUnwrap(UUID(uuidString: "C74A112D-4997-4F67-B958-8A80E1A0F8BB"))
    }

    override func tearDown() {
        accountID = nil
        useCase = nil
        accountRepository = nil
        super.tearDown()
    }

    func testExecuteWhenNoAccountsReturnsEmptyArray() async throws {
        accountRepository.accountsResult = .success([])

        let accountSummaries = try await useCase.execute()

        XCTAssertTrue(accountSummaries.isEmpty)
    }

    func testExecuteWhenOneAccountReturnsAccountSummaryWithIDAndName() async throws {
        let account = Account(id: accountID, name: "Test", type: .primary, currency: "GBP")
        accountRepository.accountsResult = .success([account])
        accountRepository.balanceResult = .success([account.id: Money(minorUnits: 0, currency: "GBP")])

        let accountSummaries = try await useCase.execute()

        XCTAssertEqual(accountSummaries.count, 1)
        let accountSummary = try XCTUnwrap(accountSummaries.first)

        XCTAssertEqual(accountSummary.id, accountID)
        XCTAssertEqual(accountSummary.name, "Test")
    }

    func testExecuteWhenOneAccountAndBalanceReturnsAccountSummaryWithBalance() async throws {
        let account = Account(id: accountID, name: "Test", type: .primary, currency: "GBP")
        let balance = Money(minorUnits: 1234, currency: "GBP")
        accountRepository.accountsResult = .success([account])
        accountRepository.balanceResult = .success([account.id: balance])

        let accountSummaries = try await useCase.execute()

        XCTAssertEqual(accountSummaries.count, 1)
        let accountSummary = try XCTUnwrap(accountSummaries.first)

        XCTAssertEqual(accountSummary.balance.minorUnits, 1234)
        XCTAssertEqual(accountSummary.balance.currency, "GBP")
    }

    func testExecuteWhenFetchingAccountsErrorsThrowsError() async {
        accountRepository.accountsResult = .failure(.unknown)

        var useCaseError: FetchAccountSummariesError?
        do {
            _ = try await useCase.execute()
        } catch let error {
            useCaseError = error as? FetchAccountSummariesError
        }

        XCTAssertEqual(useCaseError, .unknown)
    }

    func testExecuteWhenFetchingBalanceErrorsThrowsError() async {
        let account = Account(id: accountID, name: "Test", type: .primary, currency: "GBP")
        accountRepository.accountsResult = .success([account])
        accountRepository.balanceResult = .failure(.unknown)

        var useCaseError: FetchAccountSummariesError?
        do {
            _ = try await useCase.execute()
        } catch let error {
            useCaseError = error as? FetchAccountSummariesError
        }

        XCTAssertEqual(useCaseError, .unknown)
    }

}
