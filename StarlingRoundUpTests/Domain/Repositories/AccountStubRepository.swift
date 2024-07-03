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
    var accountResult: Result<Account?, AccountRepositoryError> = .failure(.unknown)

    private(set) var lastBalanceAccountID: Account.ID?
    var balanceResult: Result<[String: Balance], AccountRepositoryError> = .failure(.unknown)

    init() {}

    func accounts() async throws -> [Account] {
        try accountsResult.get()
    }

    func account(withID id: Account.ID) async throws -> Account? {
        lastAccountID = id

        return try accountResult.get()
    }

    func balance(for accountID: Account.ID) async throws -> Balance? {
        lastBalanceAccountID = accountID

        let balanceResults = try balanceResult.get()
        return balanceResults[accountID]
    }

}
