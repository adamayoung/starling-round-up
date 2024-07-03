//
//  FetchSavingsGoals.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

final class FetchSavingsGoals: FetchSavingsGoalsUseCase {

    private let savingsGoalRepository: any SavingsGoalRepository

    init(savingsGoalRepository: any SavingsGoalRepository) {
        self.savingsGoalRepository = savingsGoalRepository
    }

    func execute(accountID: Account.ID) async throws -> [SavingsGoal] {
        let savingsGoals = try await savingsGoalRepository.savingsGoals(for: accountID)
        let activeSavingsGoals = savingsGoals.filter { $0.state == .active }
        return activeSavingsGoals
    }

}
