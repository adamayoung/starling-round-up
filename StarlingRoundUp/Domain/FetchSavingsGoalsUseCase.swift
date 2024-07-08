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

enum FetchSavingsGoalsError: LocalizedError {

    case unauthorized
    case forbidden
    case accountNotFound
    case unknown

    var errorDescription: String? {
        switch self {
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
