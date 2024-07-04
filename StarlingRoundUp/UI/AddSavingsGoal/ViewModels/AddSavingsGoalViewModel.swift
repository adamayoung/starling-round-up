//
//  AddSavingsGoalViewModel.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

final class AddSavingsGoalViewModel: AddSavingsGoalViewModeling {

    let accountID: Account.ID
    let currency = "GBP"

    var savingsGoalName: String? {
        didSet {
            onFormValidChanged?(isFormValid)
        }
    }

    var savingsGoalTarget: Int? {
        didSet {
            onFormValidChanged?(isFormValid)
        }
    }

    var isFormValid: Bool {
        do {
            try savingGoalInput.validate()
        } catch {
            return false
        }

        return true
    }

    var onFormValidChanged: ((Bool) -> Void)?

    private let createSavingsGoalUseCase: any CreateSavingsGoalUseCase

    private var savingGoalInput: SavingsGoalInput {
        SavingsGoalInput(
            accountID: accountID,
            name: savingsGoalName ?? "",
            currency: currency,
            targetMinorUnits: savingsGoalTarget ?? 0
        )
    }

    init(accountID: Account.ID, createSavingsGoalUseCase: some CreateSavingsGoalUseCase) {
        self.accountID = accountID
        self.createSavingsGoalUseCase = createSavingsGoalUseCase
    }

    func save() async throws {
        try await createSavingsGoalUseCase.execute(input: savingGoalInput)
    }

}
