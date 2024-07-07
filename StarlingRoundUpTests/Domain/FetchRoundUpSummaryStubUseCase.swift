//
//  FetchRoundUpSummaryStubUseCase.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 05/07/2024.
//

import Foundation
@testable import StarlingRoundUp

final class FetchRoundUpSummaryStubUseCase: FetchRoundUpSummaryUseCase {

    var result: Result<RoundUpSummary, FetchRoundUpSummaryError> = .failure(.unknown)
    private(set) var lastAccountID: Account.ID?
    private(set) var lastTimeWindow: RoundUpTimeWindow?
    private(set) var lastDate: Date?

    func execute(
        accountID: Account.ID,
        inTimeWindow timeWindow: RoundUpTimeWindow,
        withDate date: Date
    ) async throws -> RoundUpSummary {
        lastAccountID = accountID
        lastTimeWindow = timeWindow
        lastDate = date

        return try result.get()
    }

}
