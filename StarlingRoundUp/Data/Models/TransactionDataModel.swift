//
//  TransactionDataModel.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

struct TransactionDataModel: Decodable {

    let feedItemUid: String
    let categoryUid: String
    let amount: MoneyDataModel
    let direction: TransactionDirectionDataModel
    let transactionTime: Date
    let settlementTime: Date
    let updatedAt: Date

}
