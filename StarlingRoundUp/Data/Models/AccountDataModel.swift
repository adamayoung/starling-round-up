//
//  AccountDataModel.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

struct AccountDataModel: Decodable {

    let accountUid: UUID
    let name: String
    let accountType: AccountTypeDataModel
    let defaultCategory: String
    let currency: String
    let createdAt: Date

}
