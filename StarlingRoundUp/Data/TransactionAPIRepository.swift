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

        let transactionsResponse: TransactionsResponseDataModel
        do {
            transactionsResponse = try await apiClient.perform(request)
        } catch let error {
            throw Self.mapToFetchTransactionRepositoryError(error)
        }

        let transactions = transactionsResponse.feedItems.map { TransactionMapper.map($0) }
        return transactions
    }

}

extension TransactionAPIRepository {

    private static func mapToFetchTransactionRepositoryError(_ error: Error) -> TransactionRepositoryError {
        guard let error = error as? APIClientError else {
            return .unknown
        }

        switch error {
        default:
            return .unknown
        }
    }

}
