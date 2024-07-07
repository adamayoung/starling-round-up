//
//  AccountListViewModelTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 02/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class AccountListViewModelTests: XCTestCase {

    var viewModel: AccountListViewModel!
    var fetchAccountSummariesUseCase: FetchAccountSummariesStubUseCase!

    override func setUp() {
        super.setUp()
        fetchAccountSummariesUseCase = FetchAccountSummariesStubUseCase()
        viewModel = AccountListViewModel(fetchAccountSummariesUseCase: fetchAccountSummariesUseCase)
    }

    override func tearDown() {
        viewModel = nil
        fetchAccountSummariesUseCase = nil
        super.tearDown()
    }

    func testInitAccountSummariesIsEmpty() async throws {
        XCTAssertTrue(viewModel.accountSummaries.isEmpty)
    }

    func testFetchAccountSummariesSetsAccountSummaries() async throws {
        let accountSummaries = try [
            AccountSummary(
                id: XCTUnwrap(UUID(uuidString: "E9B485CF-F132-4ADB-8748-93999B257FE1")),
                name: "Test 1",
                balance: Money(minorUnits: 1234, currency: "GBP")
            ),
            AccountSummary(
                id: XCTUnwrap(UUID(uuidString: "1337CB6B-0DC8-4827-98E4-19C4EFEA9862")),
                name: "Test 2",
                balance: Money(minorUnits: 5678, currency: "GBP")
            )
        ]
        fetchAccountSummariesUseCase.result = .success(accountSummaries)

        try await viewModel.fetchAccountSummaries()

        XCTAssertEqual(viewModel.accountSummaries, accountSummaries)
    }

    func testFetchAccountSummariesWhenErrorsThrowsError() async throws {
        fetchAccountSummariesUseCase.result = .failure(.unknown)

        var fetchAccountSummariesError: FetchAccountSummariesError?
        do {
            try await viewModel.fetchAccountSummaries()
        } catch let error {
            fetchAccountSummariesError = error as? FetchAccountSummariesError
        }

        XCTAssertEqual(fetchAccountSummariesError, .unknown)
    }

}
