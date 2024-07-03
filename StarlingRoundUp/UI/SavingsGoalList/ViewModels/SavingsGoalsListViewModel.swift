//
//  SavingsGoalsListViewModel.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

final class SavingsGoalsListViewModel: SavingsGoalsListViewModeling {

    let accountID: Account.ID
    private(set) var savingsGoals: [SavingsGoal] = []

    private let fetchSavingsGoalsUseCase: any FetchSavingsGoalsUseCase

    init(accountID: Account.ID, fetchSavingsGoalsUseCase: some FetchSavingsGoalsUseCase) {
        self.accountID = accountID
        self.fetchSavingsGoalsUseCase = fetchSavingsGoalsUseCase
    }

    func fetchSavingsGoals() async throws {
        let savingsGoals = try await fetchSavingsGoalsUseCase.execute(accountID: accountID)
        self.savingsGoals = savingsGoals
    }

}
