//
//  Transaction.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

struct Transaction: Identifiable, Sendable, Equatable {

    let id: String
    let amount: Money
    let direction: Transaction.Direction

}

extension Transaction {

    enum Direction {

        case incoming
        case outgoing

    }

}
