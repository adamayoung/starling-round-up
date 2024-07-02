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
        let accountsResponse = try await apiClient.perform(request)
        let accounts = accountsResponse.accounts.map { AccountMapper.map($0) }
        return accounts
    }

    func balance(for accountID: Account.ID) async throws -> Balance? {
        let request = BalanceRequest(accountID: accountID)
        let balanceResponse = try await apiClient.perform(request)
        let balance = BalanceMapper.map(balanceResponse.amount)
        return balance
    }

}
