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
        let account: Account?
        do {
            account = try await accountRepository.account(withID: accountID)
        } catch let error {
            throw Self.mapToFetchAccountSummaryError(error)
        }

        guard let matchingAccount = account else {
            return nil
        }

        let balance: Money?
        do {
            balance = try await accountRepository.balance(for: matchingAccount.id)
        } catch let error {
            throw Self.mapToFetchAccountSummaryError(error)
        }

        let accountSummary = AccountSummary(
            account: matchingAccount,
            balance: balance ?? Money(minorUnits: 0, currency: matchingAccount.currency)
        )

        return accountSummary
    }

}

extension FetchAccountSummary {

    private static func mapToFetchAccountSummaryError(_ error: Error) -> FetchAccountSummaryError {
        guard error as? AccountRepositoryError != nil else {
            return .unknown
        }

        return .unknown
    }

}
