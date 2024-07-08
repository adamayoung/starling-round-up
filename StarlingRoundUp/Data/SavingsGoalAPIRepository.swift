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
        let savingsGoalsResponse: SavingsGoalsResponseDataModel
        do {
            savingsGoalsResponse = try await apiClient.perform(request)
        } catch let error as APIClientError {
            throw SavingsGoalRepositoryErrorMapper.mapSavingsGoalsError(error)
        } catch {
            throw SavingsGoalRepositoryError.unknown
        }

        let savingsGoals = savingsGoalsResponse.savingsGoalList.map { SavingsGoalMapper.map($0) }
        return savingsGoals.sorted(by: {
            $0.name.localizedStandardCompare($1.name) == .orderedAscending
        })
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
        } catch let error as APIClientError {
            throw SavingsGoalRepositoryErrorMapper.mapCreateError(error)
        } catch {
            throw SavingsGoalRepositoryError.unknown
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

        let result: TransferToSavingsGoalResponseDataModel
        do {
            result = try await apiClient.perform(request)
        } catch let error as APIClientError {
            throw SavingsGoalRepositoryErrorMapper.mapTransferError(error)
        } catch {
            throw SavingsGoalRepositoryError.unknown
        }

        guard result.success else {
            throw SavingsGoalRepositoryError.unknown
        }
    }

}
