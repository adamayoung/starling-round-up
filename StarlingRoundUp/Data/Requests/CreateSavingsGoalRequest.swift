//
//  CreateSavingsGoalRequest.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

final class CreateSavingsGoalsRequest: CodableAPIRequest<
    CreateSavingsGoalsRequest.Body,
    CreateSavingsGoalResponseDataModel
> {

    init(accountID: String, name: String, currency: String, targetMinorUnits: Int) {
        let path = "/account/\(accountID)/savings-goals"
        let body = Body(
            name: name,
            currency: currency,
            target: Body.Target(
                minorUnits: targetMinorUnits,
                currency: currency
            )
        )

        super.init(path: path, method: .put, body: body)
    }

}

extension CreateSavingsGoalsRequest {

    struct Body: Encodable, Equatable {

        let name: String
        let currency: String
        let target: Body.Target
        let base64EncodedPhoto: String? = nil

    }

}

extension CreateSavingsGoalsRequest.Body {

    struct Target: Encodable, Equatable {

        let minorUnits: Int
        let currency: String

    }

}
