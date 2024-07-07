//
//  TransactionStubRepository.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation
@testable import StarlingRoundUp

final class TransactionStubRepository: TransactionRepository {

    var transactionsResult: Result<[Account.ID: [Transaction]], TransactionRepositoryError> = .failure(.unknown)
    private(set) var lastSettledTransactionsAccountID: Account.ID?
    private(set) var lastSettledTransactionsFromDate: Date?
    private(set) var lastSettledTransactionsToDate: Date?

    init() {}

    func settledTransactions(
        forAccount accountID: Account.ID,
        in dateRange: Range<Date>
    ) async throws -> [Transaction] {
        lastSettledTransactionsAccountID = accountID
        lastSettledTransactionsFromDate = dateRange.lowerBound
        lastSettledTransactionsToDate = dateRange.upperBound

        let transactionsDictionary = try transactionsResult.get()
        return transactionsDictionary[accountID, default: []]
    }

}
