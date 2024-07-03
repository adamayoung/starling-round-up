//
//  SavingsGoalStubRepository.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation
@testable import StarlingRoundUp

final class SavingsGoalStubRepository: SavingsGoalRepository {

    var savingsGoalsResult: Result<[Account.ID: [SavingsGoal]], SavingsGoalRepositoryError> = .failure(.unknown)

    init() {}

    func savingsGoals(for accountID: Account.ID) async throws -> [SavingsGoal] {
        let savingsGoalsDictionary = try savingsGoalsResult.get()
        return savingsGoalsDictionary[accountID, default: []]
    }

}
