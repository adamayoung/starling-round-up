//
//  CodableAPIRequest.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

class CodableAPIRequest<Body: Encodable & Equatable, Response: Decodable>: APIRequest {

    let path: String
    let method: APIRequestMethod
    let headers: [String: String]
    let body: Body?

    init(
        path: String,
        method: APIRequestMethod = .post,
        body: Body? = nil,
        headers: [String: String] = [:]
    ) {
        self.path = path
        self.method = method
        self.body = body
        self.headers = headers
    }

    static func == (lhs: CodableAPIRequest<Body, Response>, rhs: CodableAPIRequest<Body, Response>) -> Bool {
        lhs.path == rhs.path
            && lhs.method == rhs.method
            && lhs.headers == rhs.headers
            && lhs.body == rhs.body
    }

}
