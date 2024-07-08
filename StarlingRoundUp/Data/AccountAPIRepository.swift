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
        } catch let error as APIClientError {
            throw AccountRepositoryErrorMapper.mapAccountsError(error)
        } catch {
            throw AccountRepositoryError.unknown
        }

        let accounts = accountsResponse.accounts.map { AccountMapper.map($0) }
        return accounts
    }

    func account(withID id: Account.ID) async throws -> Account {
        let accounts = try await accounts()
        guard let matchingAccount = (accounts.first(where: { $0.id == id })) else {
            throw AccountRepositoryError.notFound
        }

        return matchingAccount
    }

    func balance(for accountID: Account.ID) async throws -> Money {
        let request = BalanceRequest(accountID: accountID)

        let balanceResponse: BalanceResponseDataModel
        do {
            balanceResponse = try await apiClient.perform(request)
        } catch let error as APIClientError {
            throw AccountRepositoryErrorMapper.mapBalanceError(error)
        } catch {
            throw SavingsGoalRepositoryError.unknown
        }

        let balance = MoneyMapper.map(balanceResponse.amount)
        return balance
    }

}
