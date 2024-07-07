//
//  SavingsGoalAPIRepository.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

final class SavingsGoalAPIRepository: SavingsGoalRepository {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func savingsGoals(for accountID: Account.ID) async throws -> [SavingsGoal] {
        let request = SavingsGoalsRequest(accountID: accountID)
        let savingsGoalsResponse = try await apiClient.perform(request)
        let savingsGoals = savingsGoalsResponse.savingsGoalList.map { SavingsGoalMapper.map($0) }
        return savingsGoals
    }

    func create(savingsGoal: SavingsGoalInput) async throws {
        let request = CreateSavingsGoalsRequest(
            accountID: savingsGoal.accountID,
            name: savingsGoal.name,
            currency: savingsGoal.currency,
            targetMinorUnits: savingsGoal.targetMinorUnits
        )

        let result: CreateSavingsGoalResponseDataModel
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw Self.mapToSavingsGoalRepositoryError(error)
        }
        guard result.success else {
            throw SavingsGoalRepositoryError.unknown
        }
    }

    func transfer(transferID: UUID, input: TransferToSavingsGoalInput) async throws {
        let request = TransferToSavingsGoalRequest(
            transferID: transferID,
            accountID: input.accountID,
            savingsGoalID: input.savingsGoalID,
            minorUnits: input.amount.minorUnits,
            currency: input.amount.currency
        )

        let result = try await apiClient.perform(request)
        guard result.success else {
            throw SavingsGoalRepositoryError.unknown
        }
    }

}

extension SavingsGoalAPIRepository {

    private static func mapToSavingsGoalRepositoryError(_ error: Error) -> SavingsGoalRepositoryError {
        guard let error = error as? APIClientError else {
            return .unknown
        }

        switch error {
        case let .badRequest(error as ErrorResponseDataModel):
            return Self.mapToSavingsGoalRepositoryError(error)

        case .unauthorized:
            return .unauthorized

        case .forbidden:
            return .forbidden

        default:
            return .unknown
        }
    }

    private static func mapToSavingsGoalRepositoryError(_ error: ErrorResponseDataModel) -> SavingsGoalRepositoryError {
        guard let firstError = error.errors.first else {
            return .unknown
        }

        switch firstError.message {
        case "INSUFFICIENT_FUNDS":
            return .insufficentFunds

        case "AMOUNT_MUST_BE_POSITIVE":
            return .amountMustBePositive

        default:
            return .unknown
        }
    }

}
