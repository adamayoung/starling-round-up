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
            .creating

        case .active:
            .active

        case .archiving:
            .archiving

        case .archived:
            .archived

        case .restoring:
            .restoring

        case .pending:
            .pending

        case .unknown:
            .unknown
        }
    }

}
