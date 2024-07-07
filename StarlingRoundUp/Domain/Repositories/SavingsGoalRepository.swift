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

    func transfer(transferID: UUID, input: TransferToSavingsGoalInput) async throws

}

enum SavingsGoalRepositoryError: Error {

    case unknown

}
