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
        queryItems: [String: String] = [:],
        method: APIRequestMethod = .get
    ) {
        super.init(
            path: path,
            queryItems: queryItems,
            method: method,
            body: nil
        )
    }

}

struct EmptyBody: Encodable, Equatable {}
