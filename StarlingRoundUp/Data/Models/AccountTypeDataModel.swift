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
    case fixTermDeposit = "FIXED_TERM_DEPOSIT"
    case unknown = "UNKNOWN"

    init(from decoder: Decoder) throws {
        self = try AccountTypeDataModel(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }

}
