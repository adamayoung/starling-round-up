//
//  RoundUpViewModelTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 05/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class RoundUpViewModelTests: XCTestCase {

    var viewModel: RoundUpViewModel!
    var accountID: Account.ID!
    var fetchRoundUpSummaryUseCase: FetchRoundUpSummaryStubUseCase!
    var transferToSavingsGoalUseCase: TransferToSavingsGoalStubUseCase!

    override func setUp() {
        super.setUp()
        accountID = "1"
        fetchRoundUpSummaryUseCase = FetchRoundUpSummaryStubUseCase()
        transferToSavingsGoalUseCase = TransferToSavingsGoalStubUseCase()
        viewModel = RoundUpViewModel(
            accountID: accountID,
            fetchRoundUpSummaryUseCase: fetchRoundUpSummaryUseCase,
            transferToSavingsGoalUseCase: transferToSavingsGoalUseCase
        )
    }

    override func tearDown() {
        viewModel = nil
        transferToSavingsGoalUseCase = nil
        fetchRoundUpSummaryUseCase = nil
        accountID = nil
        super.tearDown()
    }

    func initSelectedSavingsGoalIsNil() {
        XCTAssertNil(viewModel.selectedSavingsGoal)
    }

    func testFetchRoundUpSummarySetsRoundUpSummary() async throws {
        let roundUpSummary = Self.createRoundUpSummary()
        fetchRoundUpSummaryUseCase.result = .success(roundUpSummary)

        try await viewModel.fetchRoundUpSummary()

        XCTAssertEqual(viewModel.roundUpSummary, roundUpSummary)
        XCTAssertEqual(fetchRoundUpSummaryUseCase.lastAccountID, accountID)
        XCTAssertEqual(fetchRoundUpSummaryUseCase.lastTimeWindow, .week)
    }

    func testFetchRoundUpSumamryShouldInitiallyUseDateAtStartOfCurrentTimeWindow() async throws {
        let dateRange = RoundUpTimeWindow.week.dateRange(containing: Date())

        try? await viewModel.fetchRoundUpSummary()

        XCTAssertEqual(fetchRoundUpSummaryUseCase.lastDate, dateRange.lowerBound)
    }

    func testFetchRoundUpSummaryWhenErrorsThrowsError() async {
        fetchRoundUpSummaryUseCase.result = .failure(.unknown)

        var fetchRoundUpSummaryError: FetchRoundUpSummaryError?
        do {
            try await viewModel.fetchRoundUpSummary()
        } catch let error {
            fetchRoundUpSummaryError = error as? FetchRoundUpSummaryError
        }

        XCTAssertEqual(fetchRoundUpSummaryError, .unknown)
    }

    func testSetSelectedSavingsGoalWhenAvailableSavingsGoalExistsSetsSelectedSavingsGoal() async throws {
        let expectedSavingsGoal = Self.createSavingsGoal(id: "2")
        let savingsGoals = [
            Self.createSavingsGoal(id: "1"),
            expectedSavingsGoal,
            Self.createSavingsGoal(id: "3")
        ]
        let roundUpSummary = Self.createRoundUpSummary(availableSavingsGoals: savingsGoals)
        fetchRoundUpSummaryUseCase.result = .success(roundUpSummary)
        try await viewModel.fetchRoundUpSummary()

        viewModel.setSelectedSavingsGoal(id: expectedSavingsGoal.id)

        XCTAssertEqual(viewModel.selectedSavingsGoal, expectedSavingsGoal)
    }

    func testSetSelectedSavingsGoalWhenSavingsGoalDoesNotExistDoesNotSetSelectedSavingsGoal() async throws {
        let expectedSavingsGoal = Self.createSavingsGoal(id: "1")
        let savingsGoals = [
            expectedSavingsGoal,
            Self.createSavingsGoal(id: "2"),
            Self.createSavingsGoal(id: "3")
        ]
        let roundUpSummary = Self.createRoundUpSummary(availableSavingsGoals: savingsGoals)
        fetchRoundUpSummaryUseCase.result = .success(roundUpSummary)
        try await viewModel.fetchRoundUpSummary()
        XCTAssertEqual(viewModel.selectedSavingsGoal, expectedSavingsGoal)

        viewModel.setSelectedSavingsGoal(id: "999")

        XCTAssertEqual(viewModel.selectedSavingsGoal, expectedSavingsGoal)
    }

    func testFetchRoundUpSummaryWhenDecrementedRoundUpTimeWindowDateUsePreviousTimeWwindowDate() async throws {
        let dateRange = RoundUpTimeWindow.week.dateRange(containing: Date())
        let expectedDate = RoundUpTimeWindow.week.startDateOfPreviousTimeWindow(date: dateRange.lowerBound)
        let roundUpSummary = Self.createRoundUpSummary()
        fetchRoundUpSummaryUseCase.result = .success(roundUpSummary)

        viewModel.decrementRoundUpTimeWindowDate()
        try await viewModel.fetchRoundUpSummary()

        XCTAssertEqual(fetchRoundUpSummaryUseCase.lastDate, expectedDate)
    }

    func testFetchRoundUpSummaryWhenIncrementedRoundUpTimeWindowDateAndInFutureDoesNotUpdateCurrentDate() async throws {
        let dateRange = RoundUpTimeWindow.week.dateRange(containing: Date())
        let expectedDate = dateRange.lowerBound
        let roundUpSummary = Self.createRoundUpSummary()
        fetchRoundUpSummaryUseCase.result = .success(roundUpSummary)

        viewModel.incrementRoundUpTimeWindowDate()
        try await viewModel.fetchRoundUpSummary()

        XCTAssertEqual(fetchRoundUpSummaryUseCase.lastDate, expectedDate)
    }

    func testFetchRoundUpSummaryWhenIncrementedRoundUpTimeWindowDateAndNotInFutureUpdatesCurrentDate() async throws {
        let dateRange = RoundUpTimeWindow.week.dateRange(containing: Date())
        let expectedPreviousDate = RoundUpTimeWindow.week.startDateOfPreviousTimeWindow(date: dateRange.lowerBound)
        let expectedDate = dateRange.lowerBound
        let roundUpSummary = Self.createRoundUpSummary()
        fetchRoundUpSummaryUseCase.result = .success(roundUpSummary)

        viewModel.decrementRoundUpTimeWindowDate()
        try await viewModel.fetchRoundUpSummary()
        XCTAssertEqual(fetchRoundUpSummaryUseCase.lastDate, expectedPreviousDate)

        viewModel.incrementRoundUpTimeWindowDate()
        try await viewModel.fetchRoundUpSummary()

        XCTAssertEqual(fetchRoundUpSummaryUseCase.lastDate, expectedDate)
    }

    func testPerformTransferWhenNoRoundUpSummaryDoesNotMakeTransfer() async throws {
        try await viewModel.performTransfer()

        XCTAssertNil(transferToSavingsGoalUseCase.lastInput)
    }

    func testPerformTransferWhenNoSelectedSavingsGoalDoesNotMakeTransfer() async throws {
        let roundUpSummary = Self.createRoundUpSummary()
        fetchRoundUpSummaryUseCase.result = .success(roundUpSummary)

        try await viewModel.fetchRoundUpSummary()

        try await viewModel.performTransfer()

        XCTAssertNil(transferToSavingsGoalUseCase.lastInput)
    }

    func testPerformTransferMakesTransfer() async throws {
        let savingsGoals = [Self.createSavingsGoal(id: "sg1")]
        let roundUpSummary = Self.createRoundUpSummary(availableSavingsGoals: savingsGoals)
        fetchRoundUpSummaryUseCase.result = .success(roundUpSummary)
        transferToSavingsGoalUseCase.result = .success(())

        try await viewModel.fetchRoundUpSummary()

        let expectedInput = TransferToSavingsGoalInput(
            accountID: roundUpSummary.accountID,
            savingsGoalID: "sg1",
            amount: roundUpSummary.amount
        )

        try await viewModel.performTransfer()

        XCTAssertEqual(transferToSavingsGoalUseCase.lastInput, expectedInput)
    }

}

extension RoundUpViewModelTests {

    private static func createRoundUpSummary(
        accountID: Account.ID = "1'",
        amount: Money = Money(minorUnits: 0, currency: "GBP"),
        dateRange: Range<Date> = Date(timeIntervalSince1970: 10000) ..< Date(timeIntervalSince1970: 20000),
        timeWindow: RoundUpTimeWindow = .week,
        accountBalance: Money = Money(minorUnits: 0, currency: "GBP"),
        availableSavingsGoals: [SavingsGoal] = []
    ) -> RoundUpSummary {
        RoundUpSummary(
            accountID: accountID,
            amount: amount,
            dateRange: dateRange,
            timeWindow: timeWindow,
            accountBalance: accountBalance,
            availableSavingsGoals: availableSavingsGoals
        )
    }

    private static func createSavingsGoal(
        id: String = "1",
        name: String = "SG 1",
        target: Money = Money(minorUnits: 0, currency: "GBP"),
        totalSaved: Money = Money(minorUnits: 0, currency: "GBP"),
        savedPercentage: Int = 0,
        state: SavingsGoalState = .active
    ) -> SavingsGoal {
        SavingsGoal(
            id: id,
            name: name,
            target: target,
            totalSaved: totalSaved,
            savedPercentage: savedPercentage,
            state: state
        )
    }

}
