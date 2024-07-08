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

    func execute(accountID: Account.ID) async throws -> AccountSummary {
        let account = try await account(withID: accountID)
        let balance = try await balance(for: account)
        let accountSummary = AccountSummary(account: account, balance: balance)

        return accountSummary
    }

}

extension FetchAccountSummary {

    private func account(withID id: Account.ID) async throws -> Account {
        let account: Account
        do {
            account = try await accountRepository.account(withID: id)
        } catch let error as AccountRepositoryError {
            throw Self.mapToFetchAccountSummaryError(error)
        } catch {
            throw FetchAccountSummaryError.unknown
        }

        return account
    }

    private func balance(for account: Account) async throws -> Money {
        let balance: Money
        do {
            balance = try await accountRepository.balance(for: account.id)
        } catch let error as AccountRepositoryError {
            throw Self.mapToFetchAccountSummaryError(error)
        } catch {
            throw FetchAccountSummaryError.unknown
        }

        return balance
    }

}

extension FetchAccountSummary {

    private static func mapToFetchAccountSummaryError(
        _ error: AccountRepositoryError
    ) -> FetchAccountSummaryError {
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
