//
//  AccountAPIRepository.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

final class AccountAPIRepository: AccountRepository {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func accounts() async throws -> [Account] {
        let request = AccountsRequest()

        let accountsResponse: AccountsResponseDataModel
        do {
            accountsResponse = try await apiClient.perform(request)
        } catch let error {
            throw Self.mapToFetchAccountRepositoryError(error)
        }

        let accounts = accountsResponse.accounts.map { AccountMapper.map($0) }
        return accounts
    }

    func account(withID id: Account.ID) async throws -> Account? {
        let accounts = try await accounts()
        let matchingAccount = accounts.first(where: { $0.id == id })
        return matchingAccount
    }

    func balance(for accountID: Account.ID) async throws -> Money? {
        let request = BalanceRequest(accountID: accountID)

        let balanceResponse: BalanceResponseDataModel
        do {
            balanceResponse = try await apiClient.perform(request)
        } catch let error {
            throw Self.mapToFetchAccountRepositoryError(error)
        }

        let balance = MoneyMapper.map(balanceResponse.amount)
        return balance
    }

}

extension AccountAPIRepository {

    private static func mapToFetchAccountRepositoryError(_ error: Error) -> AccountRepositoryError {
        guard let error = error as? APIClientError else {
            return .unknown
        }

        switch error {
        default:
            return .unknown
        }
    }

}
