//
//  AccountSummary.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

struct AccountSummary: Identifiable, Sendable, Hashable {

    let id: Account.ID
    let name: String
    let balance: Money

}

extension AccountSummary {

    init(account: Account, balance: Money) {
        self.init(
            id: account.id,
            name: account.name,
            balance: balance
        )
    }

}
