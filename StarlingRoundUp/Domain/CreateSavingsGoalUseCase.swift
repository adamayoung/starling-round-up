//
//  CreateSavingsGoalUseCase.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

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

enum CreateSavingsGoalError: LocalizedError {

    case invalidName
    case invalidCurrency
    case invalidTarget
    case unauthorized
    case forbidden
    case accountNotFound
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidName:
            String(
                localized: "CREATE_SAVINGS_GOAL_INVALID_NAME",
                comment: "The Savings Goal name is not valid."
            )

        case .invalidCurrency:
            String(
                localized: "CREATE_SAVINGS_GOAL_INVALID_CURRENCY",
                comment: "The Savings Goal currency is not valid."
            )

        case .invalidTarget:
            String(
                localized: "CREATE_SAVINGS_GOAL_INVALID_TARGET",
                comment: "The Savings Goal target amount is not valid."
            )

        case .unauthorized:
            String(localized: "UNAUTHORISED_ERROR", comment: "You are not authorised to make this request.")

        case .forbidden:
            String(localized: "FORBIDDEN_ERROR", comment: "You are forbidden from making this request.")

        case .accountNotFound:
            String(localized: "ACCOUNT_NOT_FOUND", comment: "This account cannot be found.")

        case .unknown:
            String(localized: "UNKNOWN_ERROR", comment: "An unknown error occurred.")
        }
    }

}
