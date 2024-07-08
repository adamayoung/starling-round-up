//
//  AccountTypeMapper.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

struct AccountTypeMapper {

    private init() {}

    static func map(_ dataModel: AccountTypeDataModel) -> AccountType {
        switch dataModel {
        case .primary:
            .primary

        case .additional:
            .additional

        case .loan:
            .loan

        case .fixedTermDeposit:
            .fixedTermDeposit

        case .unknown:
            .unknown
        }
    }

}
