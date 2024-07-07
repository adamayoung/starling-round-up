//
//  Money.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

struct Money: Sendable, Equatable, Hashable, Comparable {

    let minorUnits: Int
    let currency: String

    func formatted() -> String {
        let balanceAmount = Double(minorUnits) / 100
        return balanceAmount.formatted(.currency(code: currency))
    }

    static func < (lhs: Money, rhs: Money) -> Bool {
        guard lhs.currency == rhs.currency else {
            return false
        }

        return lhs.minorUnits < rhs.minorUnits
    }

    static func > (lhs: Money, rhs: Money) -> Bool {
        guard lhs.currency == rhs.currency else {
            return false
        }

        return lhs.minorUnits > rhs.minorUnits
    }

}
