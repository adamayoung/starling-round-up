//
//  SavingsGoalStateMapper.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

struct SavingsGoalStateMapper {

    private init() {}

    static func map(_ dataModel: SavingsGoalStateDataModel) -> SavingsGoalState {
        switch dataModel {
        case .creating:
            return .creating

        case .active:
            return .active

        case .archiving:
            return .archiving

        case .archived:
            return .archived

        case .restoring:
            return .restoring

        case .pending:
            return .pending

        case .unknown:
            return .unknown
        }
    }

}
