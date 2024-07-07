//
//  SavingsGoalRepository.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

protocol SavingsGoalRepository {

    func savingsGoals(for accountID: Account.ID) async throws -> [SavingsGoal]

    func create(savingsGoal: SavingsGoalInput) async throws

    func transfer(amount: Money, from accountID: Account.ID, to savingsGoal: SavingsGoal.ID) async throws

}

enum SavingsGoalRepositoryError: Error {

    case unknown

}
