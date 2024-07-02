//
//  DecodableAPIRequest.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

class DecodableAPIRequest<Response: Decodable>: APIRequest {

    let path: String
    let method: APIRequestMethod
    let headers: [String: String]

    init(
        path: String,
        method: APIRequestMethod = .get,
        headers: [String: String] = [:]
    ) {
        self.path = path
        self.method = method
        self.headers = headers
    }

    static func == (lhs: DecodableAPIRequest<Response>, rhs: DecodableAPIRequest<Response>) -> Bool {
        lhs.path == rhs.path
            && lhs.method == rhs.method
            && lhs.headers == rhs.headers
    }

}
