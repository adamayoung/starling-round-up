//
//  APIStubClient.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation
@testable import StarlingRoundUp

final class APIStubClient: APIClient {

    var responseResult: Result<any Decodable, APIClientError> = .failure(.unknown)
    var lastRequest: (any APIRequest)?

    init() {}

    func perform<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        lastRequest = request

        guard let response = try responseResult.get() as? Request.Response else {
            throw APIClientError.unknown
        }

        return response
    }

}
