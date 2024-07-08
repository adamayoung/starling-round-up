//
//  TransactionRepository.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

protocol TransactionRepository {

    func settledTransactions(forAccount accountID: Account.ID, in dateRange: Range<Date>) async throws -> [Transaction]

}
