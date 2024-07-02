//
//  AccountSummary.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

struct AccountSummary: Identifiable, Sendable, Hashable {

    let id: String
    let name: String
    let balance: Balance

}

extension AccountSummary {

    init(account: Account, balance: Balance) {
        self.init(
            id: account.id,
            name: account.name,
            balance: balance
        )
    }

}
