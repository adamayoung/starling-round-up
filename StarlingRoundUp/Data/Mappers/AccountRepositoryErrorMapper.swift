//
//  AccountRepositoryErrorMapper.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 08/07/2024.
//

import Foundation

struct AccountRepositoryErrorMapper {

    private init() {}

    static func mapAccountsError(_ error: APIClientError) -> AccountRepositoryError {
        map(error)
    }

    static func mapBalanceError(_ error: APIClientError) -> AccountRepositoryError {
        map(error)
    }

}

extension AccountRepositoryErrorMapper {

    static func map(_ error: APIClientError) -> AccountRepositoryError {
        switch error {
        case .unauthorized:
            .unauthorized

        case .forbidden:
            .forbidden

        case .notFound:
            .notFound

        default:
            .unknown
        }
    }

}
