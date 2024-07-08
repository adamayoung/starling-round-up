//
//  TransactionRepositoryError.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 08/07/2024.
//

import Foundation

enum TransactionRepositoryError: Error {

    case unauthorized
    case forbidden
    case notFound
    case unknown

}
