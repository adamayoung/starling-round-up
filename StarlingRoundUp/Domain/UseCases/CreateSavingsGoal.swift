//
//  CreateSavingsGoal.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

final class CreateSavingsGoal: CreateSavingsGoalUseCase {

    private let savingsGoalRepository: any SavingsGoalRepository

    init(savingsGoalRepository: any SavingsGoalRepository) {
        self.savingsGoalRepository = savingsGoalRepository
    }

    func execute(input: SavingsGoalInput) async throws {
        try input.validate()

        do {
            try await savingsGoalRepository.create(savingsGoal: input)
        } catch let error {
            throw Self.mapToCreateSavingsGoalError(error)
        }
    }

}

extension CreateSavingsGoal {

    private static func mapToCreateSavingsGoalError(_ error: Error) -> CreateSavingsGoalError {
        guard error as? SavingsGoalRepositoryError != nil else {
            return .unknown
        }

        return .unknown
    }

}
