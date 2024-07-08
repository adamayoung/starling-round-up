//
//  CodableAPIRequest.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

class CodableAPIRequest<
    Body: Encodable & Equatable,
    Response: Decodable,
    ErrorResponse: Decodable & Error
>: APIRequest {

    let path: String
    let queryItems: [String: String]
    let method: APIRequestMethod
    let body: Body?

    init(
        path: String,
        queryItems: [String: String] = [:],
        method: APIRequestMethod = .post,
        body: Body? = nil
    ) {
        self.path = path
        self.queryItems = queryItems
        self.method = method
        self.body = body
    }

    static func == (
        lhs: CodableAPIRequest<Body, Response, ErrorResponse>,
        rhs: CodableAPIRequest<Body, Response, ErrorResponse>
    ) -> Bool {
        lhs.path == rhs.path
            && lhs.queryItems == rhs.queryItems
            && lhs.method == rhs.method
            && lhs.body == rhs.body
    }

}
