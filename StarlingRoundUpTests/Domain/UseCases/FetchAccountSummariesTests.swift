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

    override func setUp() {
        super.setUp()
        accountRepository = AccountStubRepository()
        useCase = FetchAccountSummaries(accountRepository: accountRepository)
    }

    override func tearDown() {
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
        let account = Account(id: "1", name: "Test", type: .primary, currency: "GBP")
        accountRepository.accountsResult = .success([account])
        accountRepository.balanceResult = .success([:])

        let accountSummaries = try await useCase.execute()

        XCTAssertEqual(accountSummaries.count, 1)
        let accountSummary = accountSummaries[0]

        XCTAssertEqual(accountSummary.id, "1")
        XCTAssertEqual(accountSummary.name, "Test")
    }

    func testExecuteWhenOneAccountAndNilBalanceReturnsAccountSummaryZeroBalance() async throws {
        let account = Account(id: "1", name: "Test", type: .primary, currency: "GBP")
        accountRepository.accountsResult = .success([account])
        accountRepository.balanceResult = .success([:])

        let accountSummaries = try await useCase.execute()

        XCTAssertEqual(accountSummaries.count, 1)
        let accountSummary = accountSummaries[0]

        XCTAssertEqual(accountSummary.balance.valueMinorUnits, 0)
        XCTAssertEqual(accountSummary.balance.currency, "GBP")
    }

    func testExecuteWhenOneAccountAndBalanceReturnsAccountSummaryWithBalance() async throws {
        let account = Account(id: "1", name: "Test", type: .primary, currency: "GBP")
        let balance = Balance(valueMinorUnits: 1234, currency: "GBP")
        accountRepository.accountsResult = .success([account])
        accountRepository.balanceResult = .success([account.id: balance])

        let accountSummaries = try await useCase.execute()

        XCTAssertEqual(accountSummaries.count, 1)
        let accountSummary = accountSummaries[0]

        XCTAssertEqual(accountSummary.balance.valueMinorUnits, 1234)
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
        let account = Account(id: "1", name: "Test", type: .primary, currency: "GBP")
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
