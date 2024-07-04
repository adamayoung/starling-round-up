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
        let savingsGoals: [SavingsGoal]
        do {
            savingsGoals = try await savingsGoalRepository.savingsGoals(for: accountID)
        } catch let error {
            throw Self.mapToFetchSavingsGoalsError(error)
        }

        let activeSavingsGoals = savingsGoals.filter { $0.state == .active }
        return activeSavingsGoals
    }

}

extension FetchSavingsGoals {

    private static func mapToFetchSavingsGoalsError(_ error: Error) -> FetchSavingsGoalsError {
        guard error as? SavingsGoalRepositoryError != nil else {
            return .unknown
        }

        return .unknown
    }

}
