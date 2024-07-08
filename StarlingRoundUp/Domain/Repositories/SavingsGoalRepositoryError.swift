//
//  SavingsGoalRepositoryError.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 08/07/2024.
//

import Foundation

enum SavingsGoalRepositoryError: Error {

    case unauthorized
    case forbidden
    case notFound
    case insufficientFunds
    case amountMustBePositive
    case unknown

}
