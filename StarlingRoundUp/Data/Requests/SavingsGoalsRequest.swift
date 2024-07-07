//
//  SavingsGoalsRequest.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

final class SavingsGoalsRequest: DecodableAPIRequest<SavingsGoalsResponseDataModel> {

    init(accountID: UUID) {
        let path = "/account/\(accountID.uuidString)/savings-goals"

        super.init(path: path)
    }

}
