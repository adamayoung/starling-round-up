//
//  TransferToSavingsGoal.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 07/07/2024.
//

import Foundation

final class TransferToSavingsGoal: TransferToSavingsGoalUseCase {

    private let savingsGoalRepository: any SavingsGoalRepository

    init(savingsGoalRepository: some SavingsGoalRepository) {
        self.savingsGoalRepository = savingsGoalRepository
    }

    func execute(input: TransferToSavingsGoalInput) async throws {
        do {
            try await savingsGoalRepository.transfer(
                amount: input.amount,
                from: input.accountID,
                to: input.savingsGoalID
            )
        } catch let error {
            throw Self.mapToTransferToSavingsGoalError(error)
        }
    }

}

extension TransferToSavingsGoal {

    private static func mapToTransferToSavingsGoalError(_ error: Error) -> TransferToSavingsGoalError {
        guard error is SavingsGoalRepositoryError else {
            return .unknown
        }

        return .unknown
    }

}
