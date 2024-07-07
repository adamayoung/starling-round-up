//
//  ErrorResponseDataModel.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 07/07/2024.
//

import Foundation

struct ErrorResponseDataModel: Decodable, Error {

    let errors: [ErrorDetailDataModel]
    let success: Bool

}
