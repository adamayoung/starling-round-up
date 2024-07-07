//
//  HTTPStatusCodeErrorMapper.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 07/07/2024.
//

import Foundation

struct HTTPStatusCodeErrorMapper {

    private init() {}

    static func map(_ statusCode: Int) -> APIClientError? {
        switch statusCode {
        case 200 ... 399:
            nil

        case 400:
            .badRequest(nil)

        case 401:
            .unauthorized

        case 403:
            .forbidden

        case 404:
            .notFound

        case 400 ... 499:
            .unknownClientError

        case 500 ... 599:
            .serverError

        default:
            .unknown
        }
    }

}
