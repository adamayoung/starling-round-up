//
//  APIHTTPClient.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

final class APIHTTPClient: APIClient {

    private let baseURL: String
    private let urlSession: URLSession
    private let authorizationProvider: any AuthorizationProviding

    init(
        baseURL: String,
        urlSession: URLSession,
        authorizationProvider: some AuthorizationProviding
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.authorizationProvider = authorizationProvider
    }

    func perform<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        guard let url = URL(string: "\(baseURL)\(request.path)") else {
            throw APIClientError.unknown
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        if let authorizationHeaderValue = await makeAuthorizationHeader() {
            urlRequest.addValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization")
        }

        let (data, _) = try await urlSession.data(for: urlRequest)

        let jsonDecoder = JSONDecoder.starlingAPI
        let responseObject: Request.Response
        do {
            responseObject = try jsonDecoder.decode(Request.Response.self, from: data)
        } catch {
            throw APIClientError.unknown
        }

        return responseObject
    }

}

extension APIHTTPClient {

    private func makeAuthorizationHeader() async -> String? {
        guard let token = await authorizationProvider.accessToken() else {
            return nil
        }

        return "Bearer \(token)"
    }

}
