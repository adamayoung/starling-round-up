//
//  SavingsGoal.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

struct SavingsGoal: Identifiable, Sendable, Hashable {

    let id: UUID
    let name: String
    let target: Money
    let totalSaved: Money
    let savedPercentage: Int
    let state: SavingsGoal.State

}

extension SavingsGoal {

    enum State {

        case creating
        case active
        case archiving
        case archived
        case restoring
        case pending
        case unknown

    }

}
