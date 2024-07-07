//
//  TransferToSavingsGoalRequest.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 07/07/2024.
//

import Foundation

final class TransferToSavingsGoalRequest: CodableAPIRequest<
    TransferToSavingsGoalRequest.Body,
    TransferToSavingsGoalResponseDataModel
> {

    init(
        transferID: UUID,
        accountID: UUID,
        savingsGoalID: String,
        minorUnits: Int,
        currency: String
    ) {
        let path = "/account/\(accountID.uuidString)/savings-goals/\(savingsGoalID)/add-money/\(transferID.uuidString)"
        let body = Body(
            amount: MoneyDataModel(
                minorUnits: minorUnits,
                currency: currency
            )
        )

        super.init(path: path, method: .put, body: body)
    }

}

extension TransferToSavingsGoalRequest {

    struct Body: Encodable, Equatable {

        let amount: MoneyDataModel

    }

}
