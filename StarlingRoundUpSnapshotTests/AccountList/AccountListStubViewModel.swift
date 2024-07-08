//
//  AccountListStubViewModel.swift
//  StarlingRoundUpSnapshotTests
//
//  Created by Adam Young on 08/07/2024.
//

import Foundation
@testable import StarlingRoundUp

final class AccountListStubViewModel: AccountListViewModeling {

    let accountSummaries: [AccountSummary]

    init(accountSummaries: [AccountSummary]) {
        self.accountSummaries = accountSummaries
    }

    func fetchAccountSummaries() async throws {}

}
