//
//  APIClient.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

protocol APIClient {

    func perform<Request: APIRequest>(_ request: Request) async throws -> Request.Response

}

enum APIClientError: Error {

    case encode(Error)
    case decode(Error)
    case network(Error)
    case client
    case server
    case unknown

}
