//
//  APIClientError.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 07/07/2024.
//

import Foundation

enum APIClientError: Error, Equatable {

    case badURL
    case encode(Error)
    case decode(Error)
    case network(Error)
    case badRequest(Error?)
    case unauthorized
    case forbidden
    case notFound
    case unknownClientError
    case serverError
    case unknown

    static func == (lhs: APIClientError, rhs: APIClientError) -> Bool {
        switch (lhs, rhs) {
        case (.badURL, .badURL):
            true

        case (.encode, .encode):
            true

        case (.decode, .decode):
            true

        case (.network, .network):
            true

        case (.badRequest, .badRequest):
            true

        case (.unauthorized, .unauthorized):
            true

        case (.forbidden, .forbidden):
            true

        case (.notFound, .notFound):
            true

        case (.unknownClientError, .unknownClientError):
            true

        case (.serverError, .serverError):
            true

        case (.unknown, .unknown):
            true

        default:
            false
        }
    }

}
