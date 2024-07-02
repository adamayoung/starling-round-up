//
//  AccountListViewModel.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

final class AccountListViewModel: AccountListViewModeling {

    private(set) var accountSummaries: [AccountSummary] = []

    private let fetchAccountSummariesUseCase: any FetchAccountSummariesUseCase

    init(fetchAccountSummariesUseCase: some FetchAccountSummariesUseCase) {
        self.fetchAccountSummariesUseCase = fetchAccountSummariesUseCase
    }

    func fetchAccountSummaries() async throws {
        let accountSummaries = try await fetchAccountSummariesUseCase.execute()
        self.accountSummaries = accountSummaries
    }

}
