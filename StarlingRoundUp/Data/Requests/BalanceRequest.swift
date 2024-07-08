//
//  BalanceRequest.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

final class BalanceRequest: DecodableAPIRequest<
    BalanceResponseDataModel,
    ErrorResponseDataModel<ErrorDetailDataModel>
> {

    init(accountID: UUID) {
        let path = "/accounts/\(accountID.uuidString)/balance"

        super.init(path: path)
    }

}
