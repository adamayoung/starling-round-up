//
//  TransactionMapper.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

struct TransactionMapper {

    private init() {}

    static func map(_ dataModel: TransactionDataModel) -> Transaction {
        let amount = MoneyMapper.map(dataModel.amount)
        let direction = TransactionDirectionMapper.map(dataModel.direction)

        return Transaction(
            id: dataModel.feedItemUid,
            amount: amount,
            direction: direction
        )
    }

}
