//
//  AddSavingsGoalStubViewModel.swift
//  StarlingRoundUpSnapshotTests
//
//  Created by Adam Young on 08/07/2024.
//

import Foundation
@testable import StarlingRoundUp

final class AddSavingsGoalStubViewModel: AddSavingsGoalViewModeling {

    let accountID: Account.ID
    var currency: String
    var savingsGoalName: String?
    var savingsGoalTarget: Int?
    let isFormValid: Bool
    var onFormValidChanged: ((Bool) -> Void)?

    init(
        accountID: Account.ID,
        currency: String,
        savingsGoalName: String? = nil,
        savingsGoalTarget: Int? = nil,
        isFormValid: Bool
    ) {
        self.accountID = accountID
        self.currency = currency
        self.savingsGoalName = savingsGoalName
        self.savingsGoalTarget = savingsGoalTarget
        self.isFormValid = isFormValid
    }

    func save() async throws {}

}
