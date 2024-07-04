//
//  RoundUpSummary.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

struct RoundUpSummary: Identifiable, Sendable {

    var id: String {
        "\(accountID)-\(dateRange.lowerBound.timeIntervalSince1970)-\(dateRange.upperBound.timeIntervalSince1970)"
    }

    let accountID: Account.ID
    let amount: Money
    let dateRange: Range<Date>
    let transactionsCount: Int
    let accountBalance: Money

    var hasAvailableAccountBalance: Bool {
        accountBalance >= amount
    }

    var isRoundUpAvailable: Bool {
        amount.minorUnits > 0
    }

}
