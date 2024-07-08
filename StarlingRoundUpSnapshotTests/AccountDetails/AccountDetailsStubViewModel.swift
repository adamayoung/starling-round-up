//
//  AccountDetailsStubViewModel.swift
//  StarlingRoundUpSnapshotTests
//
//  Created by Adam Young on 08/07/2024.
//

import Foundation
@testable import StarlingRoundUp

final class AccountDetailsStubViewModel: AccountDetailsViewModeling {

    let accountID: Account.ID
    let accountSummary: AccountSummary?

    init(accountID: Account.ID, accountSummary: AccountSummary?) {
        self.accountID = accountID
        self.accountSummary = accountSummary
    }

    func fetchAccountSummary() async throws {}

}
