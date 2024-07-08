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
        } catch let error as APIClientError {
            throw TransactionRepositoryErrorMapper.mapSettledTransactionsError(error)
        } catch {
            throw SavingsGoalRepositoryError.unknown
        }

        let transactions = transactionsResponse.feedItems.map { TransactionMapper.map($0) }
        return transactions
    }

}
