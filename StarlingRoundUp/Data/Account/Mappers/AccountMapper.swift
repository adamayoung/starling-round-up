//
//  AccountMapper.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

struct AccountMapper {

    private init() {}

    static func map(_ dataModel: AccountDataModel) -> Account {
        let type = AccountTypeMapper.map(dataModel.accountType)

        return Account(
            id: dataModel.accountUid,
            name: dataModel.name,
            type: type,
            currency: dataModel.currency
        )
    }

}
