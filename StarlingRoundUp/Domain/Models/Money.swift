//
//  Money.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

struct Money: Sendable, Equatable, Hashable {

    let minorUnits: Int
    let currency: String

    func formatted() -> String {
        let balanceAmount = Double(minorUnits) / 100
        return balanceAmount.formatted(.currency(code: currency))
    }

}
