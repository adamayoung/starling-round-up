//
//  AccountDetailsViewModelTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class AccountDetailsViewModelTests: XCTestCase {

    var fetchAccountSummaryUseCase: FetchAccountSummaryStubUseCase!

    override func setUp() {
        super.setUp()
        fetchAccountSummaryUseCase = FetchAccountSummaryStubUseCase()
    }

    override func tearDown() {
        fetchAccountSummaryUseCase = nil
        super.tearDown()
    }

    func testInitWithAccountIDSetsAccountID() {
        let accountID = "1"
        let viewModel = AccountDetailsViewModel(
            accountID: accountID,
            fetchAccountSummaryUseCase: fetchAccountSummaryUseCase
        )

        XCTAssertEqual(viewModel.accountID, accountID)
    }

    func testInitWithAccountSummarySetsAccountID() {
        let accountSummary = AccountSummary(id: "1", name: "Test 1", balance: Money(minorUnits: 0, currency: "GBP"))

        let viewModel = AccountDetailsViewModel(
            accountSummary: accountSummary,
            fetchAccountSummaryUseCase: fetchAccountSummaryUseCase
        )

        XCTAssertEqual(viewModel.accountID, accountSummary.id)
    }

    func testFetchAccountSummarySetsAccountSummary() async throws {
        let accountID = "1"
        let accountSummary = AccountSummary(
            id: accountID,
            name: "Test 1",
            balance: Money(minorUnits: 0, currency: "GBP")
        )
        fetchAccountSummaryUseCase.result = .success([accountID: accountSummary])
        let viewModel = AccountDetailsViewModel(
            accountID: accountID,
            fetchAccountSummaryUseCase: fetchAccountSummaryUseCase
        )

        try await viewModel.fetchAccountSummary()

        XCTAssertEqual(viewModel.accountSummary, accountSummary)
    }

    func testFetchAccountSummaryWhenErrorsThrowsError() async throws {
        fetchAccountSummaryUseCase.result = .failure(.unknown)
        let viewModel = AccountDetailsViewModel(
            accountID: "1",
            fetchAccountSummaryUseCase: fetchAccountSummaryUseCase
        )

        var fetchAccountSummaryError: FetchAccountSummaryError?
        do {
            try await viewModel.fetchAccountSummary()
        } catch let error {
            fetchAccountSummaryError = error as? FetchAccountSummaryError
        }

        XCTAssertEqual(fetchAccountSummaryError, .unknown)
    }

}
