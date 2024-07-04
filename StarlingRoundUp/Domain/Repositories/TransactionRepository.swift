//
//  TransactionRepository.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

protocol TransactionRepository {

    func settledTransactions(
        forAccount accountID: Account.ID,
        between fromDate: Date,
        and toDate: Date
    ) async throws -> [Transaction]

}

enum TransactionRepositoryError: Error {

    case unknown

}
