//
//  Account.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

struct Account: Identifiable, Sendable {

    let id: String
    let name: String
    let type: AccountType
    let currency: String

}
