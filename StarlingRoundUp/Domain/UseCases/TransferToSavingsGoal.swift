//
//  TransferToSavingsGoal.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 07/07/2024.
//

import Foundation
import os

final class TransferToSavingsGoal: TransferToSavingsGoalUseCase {

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: TransferToSavingsGoal.self)
    )

    private let savingsGoalRepository: any SavingsGoalRepository

    init(savingsGoalRepository: some SavingsGoalRepository) {
        self.savingsGoalRepository = savingsGoalRepository
    }

    func execute(input: TransferToSavingsGoalInput) async throws {
        let transferID = Self.generateNewTransactionID()
        do {
            // swiftlint:disable:next line_length
            Self.logger.trace("Transfering \(input.amount.formatted()) to savings goal \(input.savingsGoalID) in account \(input.accountID)")
            try await savingsGoalRepository.transfer(transferID: transferID, input: input)
        } catch let error as SavingsGoalRepositoryError {
            let error = Self.mapToTransferToSavingsGoalError(error)
            Self.logger.error("Failed transfering to savings goal: \(error.localizedDescription, privacy: .public)")
            throw error
        } catch {
            let error = TransferToSavingsGoalError.unknown
            Self.logger.error("Failed transfering to savings goal: \(error.localizedDescription, privacy: .public)")
            throw error
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
