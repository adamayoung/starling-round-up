//
//  AccountTypeDataModel.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

enum AccountTypeDataModel: String, Decodable {

    case primary = "PRIMARY"
    case additional = "ADDITIONAL"
    case loan = "LOAN"
    case fixedTermDeposit = "FIXED_TERM_DEPOSIT"
    case unknown = "UNKNOWN"

    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }

}
