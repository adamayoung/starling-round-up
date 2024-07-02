//
//  BalanceMapper.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

struct BalanceMapper {

    private init() {}

    static func map(_ dataModel: BalanceDataModel) -> Balance {
        Balance(
            valueMinorUnits: dataModel.minorUnits,
            currency: dataModel.currency
        )
    }

}
