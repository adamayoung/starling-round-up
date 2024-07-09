//
//  Environment.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

enum Environment {

    static let baseURL: String = {
        guard
            let baseURL = infoDictionary[Keys.baseURL] as? String,
            !baseURL.isEmpty
        else {
            fatalError("Cannot read \(Keys.baseURL) in plist file")
        }

        return baseURL

    }()

    static let accessToken: String = {
        guard
            let accessToken = infoDictionary[Keys.accessToken] as? String,
            !accessToken.isEmpty
        else {
            fatalError("Cannot read \(Keys.accessToken) in plist file")
        }

        return accessToken

    }()

    private enum Keys {
        static let baseURL = "API_BASE_URL"
        static let accessToken = "API_ACCESS_TOKEN"
    }

    private static let infoDictionary: [String: Any] = {
        guard let info = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }

        return info
    }()

}
