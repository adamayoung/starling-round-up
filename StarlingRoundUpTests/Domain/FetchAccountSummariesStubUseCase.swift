//
//  FetchAccountSummariesStubUseCase.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation
@testable import StarlingRoundUp

final class FetchAccountSummariesStubUseCase: FetchAccountSummariesUseCase {

    var result: Result<[AccountSummary], FetchAccountSummariesError> = .failure(.unknown)

    init() {}

    func execute() async throws -> [AccountSummary] {
        try result.get()
    }

}
