//
//  FetchSavingsGoalsUseCase.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

protocol FetchSavingsGoalsUseCase {

    func execute(accountID: Account.ID) async throws -> [SavingsGoal]

}

enum FetchSavingsGoalsError: Error {

    case unknown

}
