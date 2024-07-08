//
//  FetchAccountSummaries.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation
import os

final class FetchAccountSummaries: FetchAccountSummariesUseCase {

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: FetchAccountSummaries.self)
    )

    private let accountRepository: any AccountRepository

    init(accountRepository: some AccountRepository) {
        self.accountRepository = accountRepository
    }

    func execute() async throws -> [AccountSummary] {
        let accounts = try await accounts()
        guard !accounts.isEmpty else {
            return []
        }

        let accountSummaries = try await accountSummaries(for: accounts)
        return accountSummaries
    }

}

extension FetchAccountSummaries {

    private func accounts() async throws -> [Account] {
        let accounts: [Account]
        do {
            Self.logger.trace("Fetching accounts")
            accounts = try await accountRepository.accounts()
        } catch let error as AccountRepositoryError {
            let error = Self.mapToFetchAccountSummariesError(error)
            Self.logger.error("Failed fetching accounts: \(error.localizedDescription, privacy: .public)")
            throw error
        } catch {
            let error = FetchAccountSummaryError.unknown
            Self.logger.error("Failed fetching accounts: \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return accounts
    }

    private func accountSummaries(for accounts: [Account]) async throws -> [AccountSummary] {
        try await withThrowingTaskGroup(of: (Account, Money).self, returning: [AccountSummary].self) { taskGroup in
            for account in accounts {
                taskGroup.addTask {
                    do {
                        Self.logger.trace("Fetching balance for account \(account.id)")
                        return try await (account, self.accountRepository.balance(for: account.id))
                    } catch let error as AccountRepositoryError {
                        let error = Self.mapToFetchAccountSummariesError(error)
                        Self.logger.error(
                            "Failed fetching balance: \(error.localizedDescription, privacy: .public)"
                        )
                        throw error
                    } catch {
                        let error = FetchAccountSummariesError.unknown
                        Self.logger.error(
                            "Failed fetching balance: \(error.localizedDescription, privacy: .public)"
                        )
                        throw error
                    }
                }
            }

            var accountSummaries = [AccountSummary]()
            while let (account, balance) = try await taskGroup.next() {
                let accountSummary = AccountSummary(account: account, balance: balance)
                accountSummaries.append(accountSummary)
            }

            return accountSummaries
        }
    }

}

extension FetchAccountSummaries {

    private static func mapToFetchAccountSummariesError(
        _ error: AccountRepositoryError
    ) -> FetchAccountSummariesError {
        switch error {
        case .unauthorized:
            .unauthorized

        case .forbidden:
            .forbidden

        case .notFound:
            .notFound

        default:
            .unknown
        }
    }

}
