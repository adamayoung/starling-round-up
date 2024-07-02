//
//  AuthorizationProviding.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

protocol AuthorizationProviding {

    func accessToken() async -> String?

}
