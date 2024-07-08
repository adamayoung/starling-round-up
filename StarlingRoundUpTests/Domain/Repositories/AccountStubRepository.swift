//
//  AccountStubRepository.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation
@testable import StarlingRoundUp

final class AccountStubRepository: AccountRepository {

    var accountsResult: Result<[Account], AccountRepositoryError> = .failure(.unknown)

    private(set) var lastAccountID: Account.ID?
    var accountResult: Result<Account, AccountRepositoryError> = .failure(.unknown)

    private(set) var lastBalanceAccountID: Account.ID?
    var balanceResult: Result<[Account.ID: Money], AccountRepositoryError> = .failure(.unknown)

    init() {}

    func accounts() async throws -> [Account] {
        try accountsResult.get()
    }

    func account(withID id: Account.ID) async throws -> Account {
        lastAccountID = id

        return try accountResult.get()
    }

    func balance(for accountID: Account.ID) async throws -> Money {
        lastBalanceAccountID = accountID

        let balances = try balanceResult.get()
        guard let balance = balances[accountID] else {
            throw AccountRepositoryError.notFound
        }

        return balance
    }

}
