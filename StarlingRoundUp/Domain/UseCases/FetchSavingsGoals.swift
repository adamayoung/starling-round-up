//
//  FetchSavingsGoals.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation
import os

final class FetchSavingsGoals: FetchSavingsGoalsUseCase {

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: FetchSavingsGoals.self)
    )

    private let savingsGoalRepository: any SavingsGoalRepository

    init(savingsGoalRepository: any SavingsGoalRepository) {
        self.savingsGoalRepository = savingsGoalRepository
    }

    func execute(accountID: Account.ID) async throws -> [SavingsGoal] {
        let savingsGoals: [SavingsGoal]
        do {
            Self.logger.trace("Fetching savings goals for account \(accountID)")
            savingsGoals = try await savingsGoalRepository.savingsGoals(for: accountID)
        } catch let error as SavingsGoalRepositoryError {
            let error = Self.mapToFetchSavingsGoalsError(error)
            Self.logger.error("Failed fetching savings goals: \(error.localizedDescription, privacy: .public)")
            throw error
        } catch {
            let error = FetchSavingsGoalsError.unknown
            Self.logger.error("Failed fetching savings goals: \(error.localizedDescription, privacy: .public)")
            throw error
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
