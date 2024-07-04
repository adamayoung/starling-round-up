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
        between fromDate: Date,
        and toDate: Date
    ) async throws -> [Transaction] {
        lastSettledTransactionsAccountID = accountID
        lastSettledTransactionsFromDate = fromDate
        lastSettledTransactionsToDate = toDate

        let transactionsDictionary = try transactionsResult.get()
        return transactionsDictionary[accountID, default: []]
    }

}
