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
        let transferID = Self.generateNewTransactionID()
        do {
            try await savingsGoalRepository.transfer(
                transferID: transferID,
                input: input
            )
        } catch let error as SavingsGoalRepositoryError {
            throw Self.mapToTransferToSavingsGoalError(error)
        } catch {
            throw TransferToSavingsGoalError.unknown
        }
    }

}

extension TransferToSavingsGoal {

    private static func generateNewTransactionID() -> UUID {
        UUID()
    }

}

extension TransferToSavingsGoal {

    private static func mapToTransferToSavingsGoalError(
        _ error: SavingsGoalRepositoryError
    ) -> TransferToSavingsGoalError {
        switch error {
        case .unauthorized:
            .unauthorized

        case .forbidden:
            .forbidden

        case .notFound:
            .accountNotFound

        case .insufficientFunds:
            .insufficientFunds

        case .amountMustBePositive:
            .amountMustBePositive

        case .unknownSavingsGoal:
            .unknownSavingsGoal

        default:
            .unknown
        }
    }

}
