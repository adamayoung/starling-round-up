//
//  CreateSavingsGoal.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation
import os

final class CreateSavingsGoal: CreateSavingsGoalUseCase {

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: CreateSavingsGoal.self)
    )

    private let savingsGoalRepository: any SavingsGoalRepository

    init(savingsGoalRepository: any SavingsGoalRepository) {
        self.savingsGoalRepository = savingsGoalRepository
    }

    func execute(input: SavingsGoalInput) async throws {
        try input.validate()

        do {
            Self.logger.trace("Creating savings goal '\(input.name)'")
            try await savingsGoalRepository.create(savingsGoal: input)
        } catch let error as SavingsGoalRepositoryError {
            let error = Self.mapToCreateSavingsGoalError(error)
            Self.logger.error("Failed creating savings goal: \(error.localizedDescription, privacy: .public)")
            throw error
        } catch {
            let error = FetchRoundUpSummaryError.unknown
            Self.logger.error("Failed creating savings goal: \(error.localizedDescription, privacy: .public)")
            throw error
        }
    }

}

extension CreateSavingsGoal {

    private static func mapToCreateSavingsGoalError(_ error: SavingsGoalRepositoryError) -> CreateSavingsGoalError {
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
