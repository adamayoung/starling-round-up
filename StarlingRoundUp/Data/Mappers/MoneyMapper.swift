//
//  MoneyMapper.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

struct MoneyMapper {

    private init() {}

    static func map(_ dataModel: BalanceDataModel) -> Money {
        Money(
            minorUnits: dataModel.minorUnits,
            currency: dataModel.currency
        )
    }

}
