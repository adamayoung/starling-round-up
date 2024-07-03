//
//  SavingsGoalMapper.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

struct SavingsGoalMapper {

    private init() {}

    static func map(_ dataModel: SavingsGoalDataModel) -> SavingsGoal {
        let target = MoneyMapper.map(dataModel.target)
        let totalSaved = MoneyMapper.map(dataModel.totalSaved)
        let state = SavingsGoalStateMapper.map(dataModel.state)

        return SavingsGoal(
            id: dataModel.savingsGoalUid,
            name: dataModel.name,
            target: target,
            totalSaved: totalSaved,
            savedPercentage: dataModel.savedPercentage,
            state: state
        )
    }

}
