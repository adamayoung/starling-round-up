//
//  BalanceRequest.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

final class BalanceRequest: DecodableAPIRequest<BalanceResponseDataModel> {

    init(accountID: String) {
        let path = "/accounts/\(accountID)/balance"

        super.init(path: path)
    }

}
