//
//  RoundUpStubViewModel.swift
//  StarlingRoundUpSnapshotTests
//
//  Created by Adam Young on 08/07/2024.
//

import Foundation
@testable import StarlingRoundUp

final class RoundUpStubViewModel: RoundUpViewModeling {

    let accountID: Account.ID
    let roundUpSummary: RoundUpSummary?
    let selectedSavingsGoal: SavingsGoal?

    init(
        accountID: Account.ID,
        roundUpSummary: RoundUpSummary? = nil,
        selectedSavingsGoal: SavingsGoal? = nil
    ) {
        self.accountID = accountID
        self.roundUpSummary = roundUpSummary
        self.selectedSavingsGoal = selectedSavingsGoal
    }

    func fetchRoundUpSummary() async throws {}

    func decrementRoundUpTimeWindowDate() {}

    func incrementRoundUpTimeWindowDate() {}

    func setSelectedSavingsGoal(id _: SavingsGoal.ID) {}

    func performTransfer() async throws {}

}
