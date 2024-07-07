//
//  CreateSavingsGoalStubUseCase.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation
@testable import StarlingRoundUp

final class CreateSavingsGoalStubUseCase: CreateSavingsGoalUseCase {

    var result: Result<Void, CreateSavingsGoalError> = .failure(.unknown)
    private(set) var lastInput: SavingsGoalInput?

    init() {}

    func execute(input: SavingsGoalInput) async throws {
        lastInput = input
        try result.get()
    }

}
