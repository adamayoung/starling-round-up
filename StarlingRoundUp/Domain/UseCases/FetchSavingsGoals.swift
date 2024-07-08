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
        } catch let error as SavingsGoalRepositoryError {
            throw Self.mapToFetchSavingsGoalsError(error)
        } catch {
            throw FetchSavingsGoalsError.unknown
        }

        let activeSavingsGoals = savingsGoals.filter { $0.state == .active }
        return activeSavingsGoals
    }

}

extension FetchSavingsGoals {

    private static func mapToFetchSavingsGoalsError(_ error: SavingsGoalRepositoryError) -> FetchSavingsGoalsError {
        switch error {
        case .unauthorized:
            .unauthorized

        case .forbidden:
            .forbidden

        case .notFound:
            .accountNotFound

        default:
            .unknown
        }
    }

}
