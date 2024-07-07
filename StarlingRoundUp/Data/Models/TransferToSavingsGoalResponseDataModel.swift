//
//  TransferToSavingsGoalResponseDataModel.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 07/07/2024.
//

import Foundation

struct TransferToSavingsGoalResponseDataModel: Decodable {

    let success: Bool
    let transferUid: UUID?

}
