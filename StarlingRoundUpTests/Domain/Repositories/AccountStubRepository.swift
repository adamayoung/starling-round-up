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

    var lastBalanceAccountID: String?
    var balanceResult: Result<[String: Balance], AccountRepositoryError> = .failure(.unknown)

    init() {}

    func accounts() async throws -> [Account] {
        try accountsResult.get()
    }

    func balance(for accountID: String) async throws -> Balance? {
        lastBalanceAccountID = accountID

        let balanceResults = try balanceResult.get()
        return balanceResults[accountID]
    }

}
