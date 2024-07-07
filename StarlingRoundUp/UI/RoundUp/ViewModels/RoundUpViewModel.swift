//
//  RoundUpViewModel.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

final class RoundUpViewModel: RoundUpViewModeling {

    private static let timeWindow = RoundUpTimeWindow.week

    let accountID: Account.ID
    private(set) var roundUpSummary: RoundUpSummary?
    private(set) var availableSavingsGoals: [SavingsGoal] = []
    private(set) var selectedSavingsGoal: SavingsGoal?

    private let fetchRoundUpSummaryUseCase: any FetchRoundUpSummaryUseCase
    private let fetchSavingsGoalsUseCase: any FetchSavingsGoalsUseCase
    private let transferToSavingsGoalUseCase: any TransferToSavingsGoalUseCase
    private var currentFromDate: Date
    private var isFetchingRoundUpSummary = false

    init(
        accountID: Account.ID,
        fetchRoundUpSummaryUseCase: some FetchRoundUpSummaryUseCase,
        fetchSavingsGoalsUseCase: some FetchSavingsGoalsUseCase,
        transferToSavingsGoalUseCase: some TransferToSavingsGoalUseCase
    ) {
        self.accountID = accountID
        self.fetchRoundUpSummaryUseCase = fetchRoundUpSummaryUseCase
        self.fetchSavingsGoalsUseCase = fetchSavingsGoalsUseCase
        self.transferToSavingsGoalUseCase = transferToSavingsGoalUseCase
        self.currentFromDate = RoundUpViewModel.timeWindow.dateRange(containing: Date()).lowerBound
    }

    func fetchRoundUpSummary() async throws {
        guard !isFetchingRoundUpSummary else {
            return
        }

        isFetchingRoundUpSummary = true
        roundUpSummary = try await fetchRoundUpSummaryUseCase.execute(
            accountID: accountID,
            inTimeWindow: Self.timeWindow,
            withDate: currentFromDate
        )
        isFetchingRoundUpSummary = false
    }

    func refreshAvailableSavingsGoals() async throws {
        availableSavingsGoals = try await fetchSavingsGoalsUseCase.execute(accountID: accountID)
        if selectedSavingsGoal == nil {
            selectedSavingsGoal = availableSavingsGoals.first
        }
    }

    func decrementRoundUpTimeWindowDate() {
        currentFromDate = Self.timeWindow.startDateOfPreviousTimeWindow(date: currentFromDate)
    }

    func incrementRoundUpTimeWindowDate() {
        let nextDate = Self.timeWindow.startDateOfNextTimeWindow(date: currentFromDate)
        guard nextDate < Date() else {
            return
        }

        currentFromDate = nextDate
    }

    func setSelectedSavingsGoal(id: SavingsGoal.ID) {
        guard let savingsGoal = (availableSavingsGoals.first { $0.id == id }) else {
            return
        }

        selectedSavingsGoal = savingsGoal
    }

    func performTransfer() async throws {
        guard let roundUpSummary, let selectedSavingsGoal else {
            return
        }

        let input = TransferToSavingsGoalInput(
            accountID: roundUpSummary.accountID,
            savingsGoalID: selectedSavingsGoal.id,
            amount: roundUpSummary.amount
        )

        try await transferToSavingsGoalUseCase.execute(input: input)
    }

}
