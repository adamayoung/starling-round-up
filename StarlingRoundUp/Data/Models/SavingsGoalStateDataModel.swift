//
//  SavingsGoalStateDataModel.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

enum SavingsGoalStateDataModel: String, Decodable {

    case creating = "CREATING"
    case active = "ACTIVE"
    case archiving = "ARCHIVING"
    case archived = "ARCHIVED"
    case restoring = "RESTORING"
    case pending = "PENDING"
    case unknown = "UNKNOWN"

    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }

}
