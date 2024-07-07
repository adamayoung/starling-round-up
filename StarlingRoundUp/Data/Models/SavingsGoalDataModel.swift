//
//  SavingsGoalDataModel.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

struct SavingsGoalDataModel: Decodable {

    let savingsGoalUid: UUID
    let name: String
    let target: MoneyDataModel
    let totalSaved: MoneyDataModel
    let savedPercentage: Int
    let state: SavingsGoalStateDataModel

}
