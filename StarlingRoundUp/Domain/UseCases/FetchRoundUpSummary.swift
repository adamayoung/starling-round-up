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
    private let savingsGoalRepository: any SavingsGoalRepository
    private let timeZone: TimeZone

    init(
        accountRepository: some AccountRepository,
        transactionRepository: some TransactionRepository,
        savingsGoalRepository: some SavingsGoalRepository,
        timeZone: TimeZone = .autoupdatingCurrent
    ) {
        self.accountRepository = accountRepository
        self.transactionRepository = transactionRepository
        self.savingsGoalRepository = savingsGoalRepository
        self.timeZone = timeZone
    }

    func execute(
        accountID: Account.ID,
        inTimeWindow timeWindow: RoundUpTimeWindow,
        withDate date: Date
    ) async throws -> RoundUpSummary {
        let account = try await account(withID: accountID)
        async let accountBalance = accountBalance(for: account)

        let dateRange = timeWindow.dateRange(containing: date, in: timeZone)
        async let transactions = settledOutgoingTransactions(
            forAccount: account.id,
            in: dateRange,
            withCurrency: account.currency
        )

        async let savingsGoals = savingsGoals(forAccount: account.id)

        let roundUpAmount = try await Self.roundUpAmount(for: transactions, inCurrency: account.currency)

        return try await RoundUpSummary(
            accountID: account.id,
            amount: roundUpAmount,
            dateRange: dateRange,
            timeWindow: timeWindow,
            accountBalance: accountBalance,
            availableSavingsGoals: savingsGoals
        )
    }

}

extension FetchRoundUpSummary {

    private func account(withID accountID: Account.ID) async throws -> Account {
        let account: Account?
        do {
            account = try await accountRepository.account(withID: accountID)
        } catch let error as AccountRepositoryError {
            throw Self.mapToFetchRoundUpSummaryError(error)
        } catch {
            throw FetchRoundUpSummaryError.unknown
        }

        guard let foundAccount = account else {
            throw FetchRoundUpSummaryError.accountNotFound
        }

        return foundAccount
    }

    private func accountBalance(for account: Account) async throws -> Money {
        let balance: Money
        do {
            balance = try await accountRepository.balance(for: account.id)
        } catch let error as AccountRepositoryError {
            throw Self.mapToFetchRoundUpSummaryError(error)
        } catch {
            throw FetchRoundUpSummaryError.unknown
        }

        return balance
    }

    private func settledOutgoingTransactions(
        forAccount accountID: Account.ID,
        in dateRange: Range<Date>,
        withCurrency currency: String
    ) async throws -> [Transaction] {
        let transactions: [Transaction]
        do {
            transactions = try await transactionRepository.settledTransactions(forAccount: accountID, in: dateRange)
        } catch let error as TransactionRepositoryError {
            throw Self.mapToFetchRoundUpSummaryError(error)
        } catch {
            throw FetchRoundUpSummaryError.unknown
        }

        let outgoingTransactions = transactions.filter {
            $0.direction == .outgoing && $0.amount.currency == currency
        }

        return outgoingTransactions
    }

    private func savingsGoals(forAccount accountID: Account.ID) async throws -> [SavingsGoal] {
        let savingsGoals: [SavingsGoal]
        do {
            savingsGoals = try await savingsGoalRepository.savingsGoals(for: accountID)
        } catch let error as SavingsGoalRepositoryError {
            throw Self.mapToFetchRoundUpSummaryError(error)
        } catch {
            throw FetchRoundUpSummaryError.unknown
        }

        return savingsGoals
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

    private static func mapToFetchRoundUpSummaryError(
        _ error: AccountRepositoryError
    ) -> FetchRoundUpSummaryError {
        switch error {
        case .unauthorized:
            .unauthorized

        case .forbidden:
            .forbidden

        case .notFound:
            .accountNotFound

        default:
            .unknown
        }
    }

    private static func mapToFetchRoundUpSummaryError(
        _ error: TransactionRepositoryError
    ) -> FetchRoundUpSummaryError {
        switch error {
        case .unauthorized:
            .unauthorized

        case .forbidden:
            .forbidden

        case .notFound:
            .accountNotFound

        default:
            .unknown
        }
    }

    private static func mapToFetchRoundUpSummaryError(
        _ error: SavingsGoalRepositoryError
    ) -> FetchRoundUpSummaryError {
        switch error {
        case .unauthorized:
            .unauthorized

        case .forbidden:
            .forbidden

        case .notFound:
            .accountNotFound

        default:
            .unknown
        }
    }

}
