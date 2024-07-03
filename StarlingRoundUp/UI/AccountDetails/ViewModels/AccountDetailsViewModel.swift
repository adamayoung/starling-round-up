//
//  AccountDetailsViewModel.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

final class AccountDetailsViewModel: AccountDetailsViewModeling {

    let accountID: Account.ID
    private(set) var accountSummary: AccountSummary?

    private let fetchAccountSummaryUseCase: any FetchAccountSummaryUseCase

    init(accountID: Account.ID, fetchAccountSummaryUseCase: some FetchAccountSummaryUseCase) {
        self.accountID = accountID
        self.fetchAccountSummaryUseCase = fetchAccountSummaryUseCase
    }

    convenience init(accountSummary: AccountSummary, fetchAccountSummaryUseCase: some FetchAccountSummaryUseCase) {
        self.init(accountID: accountSummary.id, fetchAccountSummaryUseCase: fetchAccountSummaryUseCase)
        self.accountSummary = accountSummary
    }

    func fetchAccountSummary() async throws {
        let accountSummary = try await fetchAccountSummaryUseCase.execute(accountID: accountID)
        self.accountSummary = accountSummary
    }

}
