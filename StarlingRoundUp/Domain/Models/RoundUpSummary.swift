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
    let timeWindow: RoundUpTimeWindow
    let transactionsCount: Int
    let accountBalance: Money

    var isRoundUpAvailable: Bool {
        amount.minorUnits > 0
    }

    var hasSufficentFundsForTransfer: Bool {
        accountBalance >= amount
    }

    var isDateRangeEndInFuture: Bool {
        dateRange.upperBound > Date()
    }

}
