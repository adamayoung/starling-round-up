//
//  TransferToSavingsGoalUseCase.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 07/07/2024.
//

import Foundation

protocol TransferToSavingsGoalUseCase {

    func execute(input: TransferToSavingsGoalInput) async throws

}

struct TransferToSavingsGoalInput: Equatable {

    let accountID: Account.ID
    let savingsGoalID: SavingsGoal.ID
    let amount: Money

}

enum TransferToSavingsGoalError: LocalizedError {

    case unauthorized
    case forbidden
    case accountNotFound
    case insufficientFunds
    case amountMustBePositive
    case unknown

    var errorDescription: String? {
        switch self {
        case .unauthorized:
            String(localized: "UNAUTHORISED_ERROR", comment: "You are not authorised to make this request.")

        case .forbidden:
            String(localized: "FORBIDDEN_ERROR", comment: "You are forbidden from making this request.")

        case .accountNotFound:
            String(localized: "ACCOUNT_NOT_FOUND", comment: "This account cannot be found.")

        case .insufficientFunds:
            String(
                localized: "TRANSFER_TO_SAVINGS_GOAL_INSUFFICIENT_FUNDS",
                comment: "There are insufficent funds in your account to transfer to this Savings Goal."
            )

        case .amountMustBePositive:
            String(
                localized: "TRANSFER_TO_SAVINGS_GOAL_TRANSFER_AMOUNT_INVALID",
                comment: "The transfer amount is invalid."
            )

        case .unknown:
            String(localized: "UNKNOWN_ERROR", comment: "An unknown error occurred.")
        }
    }

}
