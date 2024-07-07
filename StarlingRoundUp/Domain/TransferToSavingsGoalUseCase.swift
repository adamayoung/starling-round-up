//
//  TransferToSavingsGoalUseCase.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 07/07/2024.
//

import Foundation

protocol TransferToSavingsGoalUseCase {

    func execute(input: TransferToSavingsGoalInput) async throws

}

struct TransferToSavingsGoalInput: Equatable {

    let accountID: String
    let savingsGoalID: String
    let amount: Money

}

enum TransferToSavingsGoalError: Error {

    case unknown

}
