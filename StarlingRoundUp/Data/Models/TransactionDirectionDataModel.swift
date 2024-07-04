//
//  TransactionDirectionDataModel.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

enum TransactionDirectionDataModel: String, Decodable {

    case `in` = "IN"
    case out = "OUT"
    case unknown = "UNKNOWN"

    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }

}
