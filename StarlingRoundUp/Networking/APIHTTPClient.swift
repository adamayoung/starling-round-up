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
        guard let initialURL = URL(string: "\(baseURL)\(request.path)") else {
            throw APIClientError.badURL
        }

        guard var urlComponents = URLComponents(url: initialURL, resolvingAgainstBaseURL: false) else {
            throw APIClientError.badURL
        }

        var queryItems = urlComponents.queryItems ?? []
        for (name, value) in request.queryItems {
            queryItems.append(URLQueryItem(name: name, value: value))
        }
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            throw APIClientError.badURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = Self.httpMethodName(from: request.method)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        if let authorizationHeaderValue = await makeAuthorizationHeader() {
            urlRequest.addValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization")
        }

        if let bodyData = try Self.bodyData(from: request) {
            urlRequest.httpBody = bodyData
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let result: (data: Data, response: URLResponse)
        do {
            result = try await urlSession.data(for: urlRequest)
        } catch let error {
            throw APIClientError.network(error)
        }

        let responseObject = try Self.decodeResponseObject(Request.Response.self, from: result.data)
        return responseObject
    }

}

extension APIHTTPClient {

    private static func httpMethodName(from method: APIRequestMethod) -> String {
        switch method {
        case .get:
            "GET"

        case .post:
            "POST"

        case .put:
            "PUT"
        }
    }

    private static func bodyData(from request: some APIRequest) throws -> Data? {
        guard let body = request.body else {
            return nil
        }

        let jsonEncoder = JSONEncoder.starlingAPI
        let data: Data
        do {
            data = try jsonEncoder.encode(body)
        } catch let error {
            throw APIClientError.encode(error)
        }

        return data
    }

    private func makeAuthorizationHeader() async -> String? {
        guard let token = await authorizationProvider.accessToken() else {
            return nil
        }

        return "Bearer \(token)"
    }

    private static func decodeResponseObject<ResponseObject: Decodable>(
        _ type: ResponseObject.Type,
        from data: Data
    ) throws -> ResponseObject {
        let jsonDecoder = JSONDecoder.starlingAPI
        let responseObject: ResponseObject
        do {
            responseObject = try jsonDecoder.decode(type, from: data)
        } catch let error {
            throw APIClientError.decode(error)
        }

        return responseObject
    }

}
