//
//  FetchAccountSummariesUseCase.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

protocol FetchAccountSummariesUseCase {

    func execute() async throws -> [AccountSummary]

}

enum FetchAccountSummariesError: Error {

    case unknown

}
