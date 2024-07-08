//
//  AccountsRequest.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

final class AccountsRequest: DecodableAPIRequest<
    AccountsResponseDataModel,
    ErrorResponseDataModel<ErrorDetailDataModel>
> {

    init() {
        let path = "/accounts"

        super.init(path: path)
    }

}
