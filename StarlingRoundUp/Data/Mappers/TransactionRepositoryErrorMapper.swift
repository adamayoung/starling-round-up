//
//  TransactionRepositoryErrorMapper.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 08/07/2024.
//

import Foundation

struct TransactionRepositoryErrorMapper {

    private init() {}

    static func mapSettledTransactionsError(_ error: APIClientError) -> TransactionRepositoryError {
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
