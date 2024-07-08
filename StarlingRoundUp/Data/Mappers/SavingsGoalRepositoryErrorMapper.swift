//
//  SavingsGoalRepositoryErrorMapper.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 08/07/2024.
//

import Foundation

struct SavingsGoalRepositoryErrorMapper {

    private init() {}

    static func mapSavingsGoalsError(_ error: APIClientError) -> SavingsGoalRepositoryError {
        map(error)
    }

    static func mapCreateError(_ error: APIClientError) -> SavingsGoalRepositoryError {
        map(error)
    }

    static func mapTransferError(_ error: APIClientError) -> SavingsGoalRepositoryError {
        switch error {
        case let .badRequest(error as TransferToSavingsGoalRequest.ErrorResponse):
            Self.map(error)

        default:
            map(error)
        }
    }

}

extension SavingsGoalRepositoryErrorMapper {

    private static func map(_ error: APIClientError) -> SavingsGoalRepositoryError {
        switch error {
        case .unauthorized:
            .unauthorized

        case .forbidden:
            .forbidden

        case .notFound:
            .notFound

        default:
            .unknown
        }
    }

}

extension SavingsGoalRepositoryErrorMapper {

    private static func map(
        _ error: TransferToSavingsGoalRequest.ErrorResponse
    ) -> SavingsGoalRepositoryError {
        guard let firstError = error.errors.first else {
            return .unknown
        }

        switch firstError.message {
        case .amountMustBePositive:
            return .amountMustBePositive

        case .insufficientFunds:
            return .insufficientFunds

        case .unknownSavingsGoal:
            return .unknownSavingsGoal

        default:
            return .unknown
        }
    }

}
