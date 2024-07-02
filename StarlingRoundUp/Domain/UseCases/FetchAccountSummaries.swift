//
//  FetchAccountSummaries.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

final class FetchAccountSummaries: FetchAccountSummariesUseCase {

    private let accountRepository: any AccountRepository

    init(accountRepository: some AccountRepository) {
        self.accountRepository = accountRepository
    }

    func execute() async throws -> [AccountSummary] {
        let accounts: [Account]
        do {
            accounts = try await accountRepository.accounts()
        } catch let error {
            throw Self.mapToFetchAccountSummariesError(error)
        }

        guard !accounts.isEmpty else {
            return []
        }

        let accountSummaries: [AccountSummary]
        do {
            accountSummaries = try await self.accountSummaries(for: accounts)
        } catch let error {
            throw Self.mapToFetchAccountSummariesError(error)
        }

        return accountSummaries
    }

}

extension FetchAccountSummaries {

    private func accountSummaries(for accounts: [Account]) async throws -> [AccountSummary] {
        try await withThrowingTaskGroup(of: (Account, Balance?).self, returning: [AccountSummary].self) { taskGroup in
            for account in accounts {
                taskGroup.addTask {
                    try await (account, self.accountRepository.balance(for: account.id))
                }
            }

            var accountSummaries = [AccountSummary]()
            while let (account, balance) = try await taskGroup.next() {
                let balance = balance ?? Balance(valueMinorUnits: 0, currency: account.currency)
                accountSummaries.append(AccountSummary(account: account, balance: balance))
            }

            return accountSummaries
        }
    }

    private static func mapToFetchAccountSummariesError(_ error: Error) -> FetchAccountSummariesError {
        guard error as? AccountRepositoryError != nil else {
            return .unknown
        }

        return .unknown
    }

}
