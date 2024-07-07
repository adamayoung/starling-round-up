//
//  SettledTransactionsRequest.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

final class SettledTransactionsRequest: DecodableAPIRequest<TransactionsResponseDataModel> {

    init(accountID: UUID, dateRange: Range<Date>) {
        let path = "/feed/account/\(accountID.uuidString)/settled-transactions-between"
        let queryItems = Self.buildQueryItems(fromDate: dateRange.lowerBound, toDate: dateRange.upperBound)

        super.init(path: path, queryItems: queryItems)
    }

}

extension SettledTransactionsRequest {

    private enum QueryItemName {
        static let minTransactionTimestamp = "minTransactionTimestamp"
        static let maxTransactionTimestamp = "maxTransactionTimestamp"
    }

    private static func buildQueryItems(fromDate: Date, toDate: Date) -> [String: String] {
        let dateFormatter = ISO8601DateFormatter()

        let queryItems = [
            QueryItemName.minTransactionTimestamp: dateFormatter.string(from: fromDate),
            QueryItemName.maxTransactionTimestamp: dateFormatter.string(from: toDate)
        ]

        return queryItems
    }

}
