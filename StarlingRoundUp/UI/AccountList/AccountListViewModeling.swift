//
//  AccountListViewModeling.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

protocol AccountListViewModeling {

    var accountSummaries: [AccountSummary] { get }

    func fetchAccountSummaries() async throws

}
