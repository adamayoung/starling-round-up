//
//  SavingsGoalRepository.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

protocol SavingsGoalRepository {

    func savingsGoals(for accountID: Account.ID) async throws -> [SavingsGoal]

}

enum SavingsGoalRepositoryError: Error {

    case unknown

}
