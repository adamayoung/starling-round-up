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
    var accountID: UUID!

    override func setUpWithError() throws {
        try super.setUpWithError()
        fetchAccountSummaryUseCase = FetchAccountSummaryStubUseCase()
        accountID = try XCTUnwrap(UUID(uuidString: "53271A33-E314-47F9-8493-F0911FF3DDA3"))
    }

    override func tearDown() {
        accountID = nil
        fetchAccountSummaryUseCase = nil
        super.tearDown()
    }

    func testInitWithAccountIDSetsAccountID() throws {
        let viewModel = AccountDetailsViewModel(
            accountID: accountID,
            fetchAccountSummaryUseCase: fetchAccountSummaryUseCase
        )

        XCTAssertEqual(viewModel.accountID, accountID)
    }

    func testInitWithAccountSummarySetsAccountID() throws {
        let accountSummary = AccountSummary(
            id: accountID,
            name: "Test 1",
            balance: Money(minorUnits: 0, currency: "GBP")
        )

        let viewModel = AccountDetailsViewModel(
            accountSummary: accountSummary,
            fetchAccountSummaryUseCase: fetchAccountSummaryUseCase
        )

        XCTAssertEqual(viewModel.accountID, accountSummary.id)
    }

    func testFetchAccountSummarySetsAccountSummary() async throws {
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
            accountID: accountID,
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
