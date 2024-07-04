//
//  FetchRoundUpSummary.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

final class FetchRoundUpSummary: FetchRoundUpSummaryUseCase {

    private let accountRepository: any AccountRepository
    private let transactionRepository: any TransactionRepository
    private let timeZone: TimeZone

    init(
        accountRepository: some AccountRepository,
        transactionRepository: some TransactionRepository,
        timeZone: TimeZone = .autoupdatingCurrent
    ) {
        self.accountRepository = accountRepository
        self.transactionRepository = transactionRepository
        self.timeZone = timeZone
    }

    func execute(
        accountID: Account.ID,
        inTimeWindow timeWindow: RoundUpTimeWindow,
        withDate date: Date
    ) async throws -> RoundUpSummary {
        let account = try await account(withID: accountID)
        let accountBalance = try await accountBalance(for: account)

        let dateRange = timeWindow.dateRange(containing: date, in: timeZone)
        let transactions = try await settledOutgoingTransactions(
            forAccount: accountID,
            in: dateRange,
            withCurrency: account.currency
        )

        let roundUpAmount = await Self.roundUpAmount(for: transactions, inCurrency: account.currency)

        return RoundUpSummary(
            accountID: account.id,
            amount: roundUpAmount,
            dateRange: dateRange,
            transactionsCount: transactions.count,
            accountBalance: accountBalance
        )
    }

}

extension FetchRoundUpSummary {

    private func account(withID accountID: Account.ID) async throws -> Account {
        let account: Account?
        do {
            account = try await accountRepository.account(withID: accountID)
        } catch let error {
            throw Self.mapToFetchRoundUpSummaryError(error)
        }

        guard let foundAccount = account else {
            throw FetchRoundUpSummaryError.accountNotFound
        }

        return foundAccount
    }

    private func accountBalance(for account: Account) async throws -> Money {
        do {
            guard let acountBalance = try await accountRepository.balance(for: account.id) else {
                return Money(minorUnits: 0, currency: account.currency)
            }

            return acountBalance
        } catch let error {
            throw Self.mapToFetchRoundUpSummaryError(error)
        }
    }

    private func settledOutgoingTransactions(
        forAccount accountID: Account.ID,
        in dateRange: Range<Date>,
        withCurrency currency: String
    ) async throws -> [Transaction] {
        let transactions: [Transaction]
        do {
            transactions = try await transactionRepository.settledTransactions(forAccount: accountID, in: dateRange)
        } catch let error {
            throw Self.mapToFetchRoundUpSummaryError(error)
        }

        let outgoingTransactions = transactions.filter {
            $0.direction == .outgoing && $0.amount.currency == currency
        }

        return outgoingTransactions
    }

}

extension FetchRoundUpSummary {

    private static func roundUpAmount(for transactions: [Transaction], inCurrency currency: String) async -> Money {
        let totalRoundUpMinorUnits = await Self.roundUp(transactions: transactions)

        return Money(minorUnits: totalRoundUpMinorUnits, currency: currency)
    }

    private static func roundUp(transactions: [Transaction]) async -> Int {
        transactions.reduce(0) { totalRoundUpAmount, transaction in
            let roundUpAmount = Self.roundUp(transaction: transaction)
            return totalRoundUpAmount + roundUpAmount
        }
    }

    private static func roundUp(transaction: Transaction) -> Int {
        let minorUnits = transaction.amount.minorUnits
        let majorUnits = Double(minorUnits) / 100
        let roundedUpMajorUnits = majorUnits.rounded(.up)
        let roundedUpMinorUnits = Int(roundedUpMajorUnits * 100)

        // Assuming if the amount is exactly a whole major unit e.g. £1.00, then the Round-Up amount will be zero.
        return roundedUpMinorUnits - minorUnits
    }

}

extension FetchRoundUpSummary {

    private static func mapToFetchRoundUpSummaryError(_ error: Error) -> FetchRoundUpSummaryError {
        if let accountRepositoryError = error as? AccountRepositoryError {
            return mapToFetchRoundUpSummaryError(accountRepositoryError)
        }

        if let transactionRepositoryError = error as? TransactionRepositoryError {
            return Self.mapToFetchRoundUpSummaryError(transactionRepositoryError)
        }

        return .unknown
    }

    private static func mapToFetchRoundUpSummaryError(_: AccountRepositoryError) -> FetchRoundUpSummaryError {
        .unknown
    }

    private static func mapToFetchRoundUpSummaryError(_: TransactionRepositoryError) -> FetchRoundUpSummaryError {
        .unknown
    }

}
