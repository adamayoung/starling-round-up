//
//  FetchAccountSummary.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

final class FetchAccountSummary: FetchAccountSummaryUseCase {

    private let accountRepository: any AccountRepository

    init(accountRepository: some AccountRepository) {
        self.accountRepository = accountRepository
    }

    func execute(accountID: Account.ID) async throws -> AccountSummary? {
        guard let account = try await account(withID: accountID) else {
            return nil
        }

        let balance = try await balance(for: account)

        let accountSummary = AccountSummary(account: account, balance: balance)
        return accountSummary
    }

}

extension FetchAccountSummary {

    private func account(withID id: Account.ID) async throws -> Account? {
        let account: Account?
        do {
            account = try await accountRepository.account(withID: id)
        } catch {
            throw FetchAccountSummaryError.account
        }

        return account
    }

    private func balance(for account: Account) async throws -> Money {
        let balance: Money?
        do {
            balance = try await accountRepository.balance(for: account.id)
        } catch {
            throw FetchAccountSummaryError.accountBalance
        }

        return balance ?? Money(minorUnits: 0, currency: account.currency)
    }

}
