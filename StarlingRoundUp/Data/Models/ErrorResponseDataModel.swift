//
//  ErrorResponseDataModel.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 07/07/2024.
//

import Foundation

struct ErrorResponseDataModel<ErrorDetail: Decodable>: Decodable, Error {

    let errors: [ErrorDetail]
    let success: Bool

}
