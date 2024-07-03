//
//  FetchAccountSummaryUseCase.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

protocol FetchAccountSummaryUseCase {

    func execute(accountID: Account.ID) async throws -> AccountSummary?

}

enum FetchAccountSummaryError: Error {

    case unknown

}
