//
//  SavingsGoalsListViewModelTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class SavingsGoalsListViewModelTests: XCTestCase {

    var viewModel: SavingsGoalsListViewModel!
    var accountID: Account.ID!
    var fetchSavingsGoalsUseCase: FetchSavingsGoalsStubUseCase!

    override func setUp() {
        super.setUp()
        accountID = "1"
        fetchSavingsGoalsUseCase = FetchSavingsGoalsStubUseCase()
        viewModel = SavingsGoalsListViewModel(accountID: accountID, fetchSavingsGoalsUseCase: fetchSavingsGoalsUseCase)
    }

    override func tearDown() {
        viewModel = nil
        fetchSavingsGoalsUseCase = nil
        accountID = nil
        super.tearDown()
    }

    func testInitAccountSummariesIsEmpty() async throws {
        XCTAssertTrue(viewModel.savingsGoals.isEmpty)
    }

    func testFetchSavingsGoalsSetsSavingsGoals() async throws {
        let accountID = "1"
        let savingsGoals = [
            SavingsGoal(
                id: "sg1",
                name: "SG 1",
                target: Money(minorUnits: 1, currency: "GBP"),
                totalSaved: Money(minorUnits: 0, currency: "GBP"),
                savedPercentage: 0,
                state: .active
            ),
            SavingsGoal(
                id: "sg2",
                name: "SG 2",
                target: Money(minorUnits: 100, currency: "GBP"),
                totalSaved: Money(minorUnits: 50, currency: "GBP"),
                savedPercentage: 50,
                state: .active
            )
        ]
        fetchSavingsGoalsUseCase.result = .success([accountID: savingsGoals])

        try await viewModel.fetchSavingsGoals()

        XCTAssertEqual(viewModel.savingsGoals, savingsGoals)
    }

    func testFetchAccountSummaryWhenErrorsThrowsError() async throws {
        fetchSavingsGoalsUseCase.result = .failure(.unknown)

        var fetchSavingsGoalsError: FetchSavingsGoalsError?
        do {
            try await viewModel.fetchSavingsGoals()
        } catch let error {
            fetchSavingsGoalsError = error as? FetchSavingsGoalsError
        }

        XCTAssertEqual(fetchSavingsGoalsError, .unknown)
    }

}
