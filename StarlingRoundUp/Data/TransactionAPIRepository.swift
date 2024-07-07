//
//  TransactionAPIRepository.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

final class TransactionAPIRepository: TransactionRepository {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func settledTransactions(
        forAccount accountID: Account.ID,
        in dateRange: Range<Date>
    ) async throws -> [Transaction] {
        let request = SettledTransactionsRequest(accountID: accountID, dateRange: dateRange)
        let transactionsResponse = try await apiClient.perform(request)
        let transactions = transactionsResponse.feedItems.map { TransactionMapper.map($0) }
        return transactions
    }

}
