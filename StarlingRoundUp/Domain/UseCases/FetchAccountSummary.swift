//
//  FetchAccountSummary.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation
import os

final class FetchAccountSummary: FetchAccountSummaryUseCase {

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: FetchAccountSummary.self)
    )

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
            Self.logger.trace("Fetching account \(id)")
            account = try await accountRepository.account(withID: id)
        } catch let error as AccountRepositoryError {
            let error = Self.mapToFetchAccountSummaryError(error)
            Self.logger.error("Failed fetching account: \(error.localizedDescription, privacy: .public)")
            throw error
        } catch {
            let error = FetchAccountSummaryError.unknown
            Self.logger.error("Failed fetching account: \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return account
    }

    private func balance(for account: Account) async throws -> Money {
        let balance: Money
        do {
            Self.logger.trace("Fetching balance for account \(account.id)")
            balance = try await accountRepository.balance(for: account.id)
        } catch let error as AccountRepositoryError {
            let error = Self.mapToFetchAccountSummaryError(error)
            Self.logger.error("Failed fetching balance: \(error.localizedDescription, privacy: .public)")
            throw error
        } catch {
            let error = FetchAccountSummaryError.unknown
            Self.logger.error("Failed fetching balance: \(error.localizedDescription, privacy: .public)")
            throw error
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
