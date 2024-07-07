//
//  FetchRoundUpSummaryUseCase.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

protocol FetchRoundUpSummaryUseCase {

    func execute(
        accountID: Account.ID,
        inTimeWindow timeWindow: RoundUpTimeWindow,
        withDate date: Date
    ) async throws -> RoundUpSummary

}

enum FetchRoundUpSummaryError: Error {

    case accountNotFound
    case account
    case savingsGoals
    case transactions
    case unknown

}
