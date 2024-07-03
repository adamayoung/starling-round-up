//
//  FetchAccountSummaryTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class FetchAccountSummaryTests: XCTestCase {

    var useCase: FetchAccountSummary!
    var accountRepository: AccountStubRepository!

    override func setUp() {
        super.setUp()
        accountRepository = AccountStubRepository()
        useCase = FetchAccountSummary(accountRepository: accountRepository)
    }

    override func tearDown() {
        useCase = nil
        accountRepository = nil
        super.tearDown()
    }

    func testExecuteWhenAccountDoesNotExistReturnsNil() async throws {
        accountRepository.accountResult = .success(nil)

        let accountSummary = try await useCase.execute(accountID: "1")

        XCTAssertNil(accountSummary)
    }

    func testExecuteWhenAccountExistsAndBalanceIsNilReturnsAccountSummaryWithZeroBalance() async throws {
        let account = Account(id: "1", name: "Test 1", type: .primary, currency: "GBP")
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        let expectedBalance = Balance(minorUnits: 0, currency: "GBP")

        let accountSummary = try await useCase.execute(accountID: "1")

        XCTAssertEqual(accountSummary?.id, account.id)
        XCTAssertEqual(accountSummary?.name, account.name)
        XCTAssertEqual(accountSummary?.balance, expectedBalance)
    }

    func testExecuteWhenAccountExistsAndHasABalanceReturnsAccountSummaryWithBalance() async throws {
        let account = Account(id: "1", name: "Test 1", type: .primary, currency: "GBP")
        let balance = Balance(minorUnits: 1234, currency: "GBP")
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([account.id: balance])

        let accountSummary = try await useCase.execute(accountID: "1")

        XCTAssertEqual(accountSummary?.id, account.id)
        XCTAssertEqual(accountSummary?.name, account.name)
        XCTAssertEqual(accountSummary?.balance, balance)
    }

    func testExecuteWhenFetchAccountErrorsThrowsError() async {
        accountRepository.accountResult = .failure(.unknown)

        var useCaseError: FetchAccountSummaryError?
        do {
            _ = try await useCase.execute(accountID: "1")
        } catch let error {
            useCaseError = error as? FetchAccountSummaryError
        }

        XCTAssertEqual(useCaseError, .unknown)
    }

    func testExecuteWhenFetchBalanceErrorsThrowsError() async {
        let account = Account(id: "1", name: "Test 1", type: .primary, currency: "GBP")
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .failure(.unknown)

        var useCaseError: FetchAccountSummaryError?
        do {
            _ = try await useCase.execute(accountID: "1")
        } catch let error {
            useCaseError = error as? FetchAccountSummaryError
        }

        XCTAssertEqual(useCaseError, .unknown)
    }

}
