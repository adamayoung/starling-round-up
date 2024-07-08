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
    private(set) var selectedSavingsGoal: SavingsGoal?

    private let fetchRoundUpSummaryUseCase: any FetchRoundUpSummaryUseCase
    private let transferToSavingsGoalUseCase: any TransferToSavingsGoalUseCase
    private var currentFromDate: Date
    private var isFetchingRoundUpSummary = false

    init(
        accountID: Account.ID,
        fetchRoundUpSummaryUseCase: some FetchRoundUpSummaryUseCase,
        transferToSavingsGoalUseCase: some TransferToSavingsGoalUseCase
    ) {
        self.accountID = accountID
        self.fetchRoundUpSummaryUseCase = fetchRoundUpSummaryUseCase
        self.transferToSavingsGoalUseCase = transferToSavingsGoalUseCase
        self.currentFromDate = RoundUpViewModel.timeWindow.dateRange(containing: Date()).lowerBound
    }

    func fetchRoundUpSummary() async throws {
        guard !isFetchingRoundUpSummary else {
            return
        }

        isFetchingRoundUpSummary = true
        let roundUpSummary = try await fetchRoundUpSummaryUseCase.execute(
            accountID: accountID,
            inTimeWindow: Self.timeWindow,
            withDate: currentFromDate
        )

        if let selectedSavingsGoal, !roundUpSummary.availableSavingsGoals.contains(selectedSavingsGoal) {
            self.selectedSavingsGoal = nil
        }

        if selectedSavingsGoal == nil {
            selectedSavingsGoal = roundUpSummary.availableSavingsGoals.first
        }

        self.roundUpSummary = roundUpSummary
        isFetchingRoundUpSummary = false
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
        let availableSavingsGoals = roundUpSummary?.availableSavingsGoals ?? []
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
