//
//  TransactionDirectionMapper.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

struct TransactionDirectionMapper {

    private init() {}

    static func map(_ dataModel: TransactionDirectionDataModel) -> Transaction.Direction {
        switch dataModel {
        case .in:
            .incoming

        case .out:
            .outgoing

        case .unknown:
            .unknown
        }
    }

}
