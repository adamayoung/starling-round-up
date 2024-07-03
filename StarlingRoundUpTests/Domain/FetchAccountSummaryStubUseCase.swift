//
//  FetchAccountSummaryStubUseCase.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation
@testable import StarlingRoundUp

final class FetchAccountSummaryStubUseCase: FetchAccountSummaryUseCase {

    var result: Result<[Account.ID: AccountSummary], FetchAccountSummaryError> = .failure(.unknown)

    func execute(accountID: Account.ID) async throws -> AccountSummary? {
        let accountSummaries = try result.get()
        return accountSummaries[accountID]
    }

}
