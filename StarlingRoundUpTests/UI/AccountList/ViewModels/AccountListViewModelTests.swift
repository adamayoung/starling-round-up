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
    var fetchAccountSummariesUseCase: FetchAccountSummariesStub!

    override func setUp() {
        super.setUp()
        fetchAccountSummariesUseCase = FetchAccountSummariesStub()
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
        let accountSummaries = [
            AccountSummary(id: "1", name: "Test 1", balance: Balance(minorUnits: 1234, currency: "GBP")),
            AccountSummary(id: "2", name: "Test 2", balance: Balance(minorUnits: 5678, currency: "GBP"))
        ]
        fetchAccountSummariesUseCase.result = .success(accountSummaries)

        try await viewModel.fetchAccountSummaries()

        XCTAssertEqual(viewModel.accountSummaries, accountSummaries)
    }

}
