//
//  TransferToSavingsGoalStubUseCase.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 07/07/2024.
//

import Foundation
@testable import StarlingRoundUp

final class TransferToSavingsGoalStubUseCase: TransferToSavingsGoalUseCase {

    var result: Result<Void, TransferToSavingsGoalError> = .failure(.unknown)
    private(set) var lastInput: TransferToSavingsGoalInput?

    init() {}

    func execute(input: TransferToSavingsGoalInput) async throws {
        lastInput = input

        try result.get()
    }

}
