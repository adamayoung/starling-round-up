//
//  AccountRepository.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

protocol AccountRepository {

    func accounts() async throws -> [Account]

    func account(withID id: Account.ID) async throws -> Account?

    func balance(for accountID: Account.ID) async throws -> Balance?

}

enum AccountRepositoryError: Error {

    case unknown

}
