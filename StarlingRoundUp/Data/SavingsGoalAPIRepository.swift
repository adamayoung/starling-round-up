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

    func create(savingsGoal _: SavingsGoalInput) async throws {}

}
