//
//  APIRequest.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

protocol APIRequest: Identifiable, Equatable {

    associatedtype Response: Decodable

    var path: String { get }
    var method: APIRequestMethod { get }
    var headers: [String: String] { get }

}
