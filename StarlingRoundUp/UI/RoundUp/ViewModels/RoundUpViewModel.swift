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
    var selectedSavingsGoal: SavingsGoal?

    private let fetchRoundUpSummaryUseCase: any FetchRoundUpSummaryUseCase
    private let fetchSavingsGoalsUseCase: any FetchSavingsGoalsUseCase
    private var currentFromDate = RoundUpViewModel.timeWindow.dateRange(containing: Date()).lowerBound
    private var isFetchingRoundUpSummary = false

    init(
        accountID: Account.ID,
        fetchRoundUpSummaryUseCase: some FetchRoundUpSummaryUseCase,
        fetchSavingsGoalsUseCase: some FetchSavingsGoalsUseCase
    ) {
        self.accountID = accountID
        self.fetchRoundUpSummaryUseCase = fetchRoundUpSummaryUseCase
        self.fetchSavingsGoalsUseCase = fetchSavingsGoalsUseCase
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
        currentFromDate = Self.timeWindow.startDateOfNextTimeWindow(date: currentFromDate)
    }

    func setSelectedSavingsGoal(id: SavingsGoal.ID) {
        selectedSavingsGoal = availableSavingsGoals.first { $0.id == id }
    }

    func performTransfer() async throws {
        print("Transfering...")
    }

}
