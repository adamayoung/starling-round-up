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
    var accountID: UUID!

    override func setUpWithError() throws {
        try super.setUpWithError()
        accountRepository = AccountStubRepository()
        useCase = FetchAccountSummary(accountRepository: accountRepository)
        accountID = try XCTUnwrap(UUID(uuidString: "C74A112D-4997-4F67-B958-8A80E1A0F8BB"))
    }

    override func tearDown() {
        accountID = nil
        useCase = nil
        accountRepository = nil
        super.tearDown()
    }

    func testExecuteWhenAccountDoesNotExistThrowsNotFoundError() async {
        accountRepository.accountResult = .failure(.notFound)

        var useCaseError: FetchAccountSummaryError?
        do {
            _ = try await useCase.execute(accountID: accountID)
        } catch let error {
            useCaseError = error as? FetchAccountSummaryError
        }

        XCTAssertEqual(useCaseError, .notFound)
    }

    func testExecuteWhenAccountExistsAndHasABalanceReturnsAccountSummaryWithBalance() async throws {
        let account = Account(id: accountID, name: "Test 1", type: .primary, currency: "GBP")
        let balance = Money(minorUnits: 1234, currency: "GBP")
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([account.id: balance])

        let accountSummary = try await useCase.execute(accountID: accountID)

        XCTAssertEqual(accountSummary.id, account.id)
        XCTAssertEqual(accountSummary.name, account.name)
        XCTAssertEqual(accountSummary.balance, balance)
    }

    func testExecuteWhenFetchAccountErrorsThrowsError() async {
        accountRepository.accountResult = .failure(.unknown)

        var useCaseError: FetchAccountSummaryError?
        do {
            _ = try await useCase.execute(accountID: accountID)
        } catch let error {
            useCaseError = error as? FetchAccountSummaryError
        }

        XCTAssertEqual(useCaseError, .unknown)
    }

    func testExecuteWhenFetchBalanceErrorsThrowsError() async {
        let account = Account(id: accountID, name: "Test 1", type: .primary, currency: "GBP")
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .failure(.unknown)

        var useCaseError: FetchAccountSummaryError?
        do {
            _ = try await useCase.execute(accountID: accountID)
        } catch let error {
            useCaseError = error as? FetchAccountSummaryError
        }

        XCTAssertEqual(useCaseError, .unknown)
    }

}
