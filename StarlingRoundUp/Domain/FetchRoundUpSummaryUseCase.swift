//
//  FetchRoundUpSummaryUseCase.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

protocol FetchRoundUpSummaryUseCase {

    func execute(accountID: Account.ID) async throws -> RoundUpSummary

    func execute(accountID: Account.ID, timeWindow: RoundUpTimeWindow) async throws -> RoundUpSummary

}
