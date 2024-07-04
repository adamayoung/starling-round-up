//
//  DecodableAPIRequest.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

class DecodableAPIRequest<Response: Decodable>: CodableAPIRequest<EmptyBody, Response> {

    init(
        path: String,
        method: APIRequestMethod = .get,
        headers: [String: String] = [:]
    ) {
        super.init(
            path: path,
            method: method,
            body: nil,
            headers: headers
        )
    }

}

struct EmptyBody: Encodable, Equatable {}
