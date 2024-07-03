//
//  SavingsGoalsRequest.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

final class SavingsGoalsRequest: DecodableAPIRequest<SavingsGoalsResponseDataModel> {

    init(accountID: String) {
        let path = "/accounts/\(accountID)/savings-goals"

        super.init(path: path)
    }

}
