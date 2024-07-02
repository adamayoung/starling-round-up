//
//  Balance.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

struct Balance: Sendable, Equatable, Hashable {

    let minorUnits: Int
    let currency: String

    var formattedValue: String {
        let balanceAmount = Double(minorUnits) / 100
        return balanceAmount.formatted(.currency(code: currency))
    }

}
