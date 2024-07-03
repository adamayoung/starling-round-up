//
//  CreateSavingsGoalUseCase.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

protocol CreateSavingsGoalUseCase {

    func execute(input: SavingsGoalInput) async throws

}

struct SavingsGoalInput: Equatable {

    let accountID: Account.ID
    let name: String
    let currency: String
    let targetMinorUnits: Int

    func validate() throws {
        guard !name.isEmpty else {
            throw CreateSavingsGoalError.invalidName
        }

        guard !currency.isEmpty else {
            throw CreateSavingsGoalError.invalidCurrency
        }

        guard targetMinorUnits > 0 else {
            throw CreateSavingsGoalError.invalidTarget
        }
    }

}

enum CreateSavingsGoalError: Error {

    case invalidName
    case invalidCurrency
    case invalidTarget
    case unknown

}
