//
//  FetchSavingsGoalsStubUseCase.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation
@testable import StarlingRoundUp

final class FetchSavingsGoalsStubUseCase: FetchSavingsGoalsUseCase {

    var result: Result<[Account.ID: [SavingsGoal]], FetchSavingsGoalsError> = .failure(.unknown)

    func execute(accountID: Account.ID) async throws -> [SavingsGoal] {
        let savingsGoals = try result.get()
        return savingsGoals[accountID, default: []]
    }

}
