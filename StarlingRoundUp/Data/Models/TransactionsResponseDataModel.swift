//
//  TransactionsResponseDataModel.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

struct TransactionsResponseDataModel: Decodable {

    let feedItems: [TransactionDataModel]

}
