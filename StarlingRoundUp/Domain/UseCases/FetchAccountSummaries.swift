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
            accounts = try await accountRepository.accounts()
        } catch {
            throw FetchAccountSummariesError.accounts
        }

        return accounts
    }

    private func accountSummaries(for accounts: [Account]) async throws -> [AccountSummary] {
        try await withThrowingTaskGroup(of: (Account, Money?).self, returning: [AccountSummary].self) { taskGroup in
            for account in accounts {
                taskGroup.addTask {
                    do {
                        return try await (account, self.accountRepository.balance(for: account.id))
                    } catch {
                        throw FetchAccountSummariesError.accountBalance
                    }
                }
            }

            var accountSummaries = [AccountSummary]()
            while let (account, balance) = try await taskGroup.next() {
                let balance = balance ?? Money(minorUnits: 0, currency: account.currency)
                accountSummaries.append(AccountSummary(account: account, balance: balance))
            }

            return accountSummaries
        }
    }

}
