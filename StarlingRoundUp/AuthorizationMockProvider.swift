//
//  AuthorizationMockProvider.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

final class AuthorizationMockProvider: AuthorizationProviding {

    private let accessToken: String

    init(accessToken: String) {
        self.accessToken = accessToken
    }

    func accessToken() async -> String? {
        accessToken
    }

}
