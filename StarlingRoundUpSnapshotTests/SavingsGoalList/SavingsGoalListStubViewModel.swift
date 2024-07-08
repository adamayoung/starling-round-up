//
//  SavingsGoalListStubViewModel.swift
//  StarlingRoundUpSnapshotTests
//
//  Created by Adam Young on 08/07/2024.
//

import Foundation
@testable import StarlingRoundUp

final class SavingsGoalListStubViewModel: SavingsGoalsListViewModeling {

    let accountID: Account.ID
    let savingsGoals: [SavingsGoal]

    init(accountID: Account.ID, savingsGoals: [SavingsGoal]) {
        self.accountID = accountID
        self.savingsGoals = savingsGoals
    }

    func fetchSavingsGoals() async throws {}

}
