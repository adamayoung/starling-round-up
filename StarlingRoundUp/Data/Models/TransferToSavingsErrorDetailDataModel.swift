//
//  TransferToSavingsErrorDetailDataModel.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 08/07/2024.
//

import Foundation

struct TransferToSavingsErrorDetailDataModel: Decodable {

    let message: TransferToSavingsErrorDetailDataModel.ErrorCode

}

extension TransferToSavingsErrorDetailDataModel {

    enum ErrorCode: String, Decodable {

        case amountMustBePositive = "AMOUNT_MUST_BE_POSITIVE"
        case insufficientFunds = "INSUFFICIENT_FUNDS"
        case unknownSavingsGoal = "UNKNOWN_SAVINGS_GOAL"
        case unknown = "UNKNOWN"

        init(from decoder: Decoder) throws {
            self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
        }

    }

}
