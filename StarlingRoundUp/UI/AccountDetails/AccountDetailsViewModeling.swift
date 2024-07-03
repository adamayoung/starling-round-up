//
//  AccountDetailsViewModeling.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

protocol AccountDetailsViewModeling {

    var accountID: Account.ID { get }
    var accountSummary: AccountSummary? { get }

    func fetchAccountSummary() async throws

}
