//
//  RoundUpViewModeling.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

protocol RoundUpViewModeling: AnyObject {

    var accountID: Account.ID { get }
    var roundUpSummary: RoundUpSummary? { get }
    var selectedSavingsGoal: SavingsGoal? { get }

    func fetchRoundUpSummary() async throws

    func decrementRoundUpTimeWindowDate()

    func incrementRoundUpTimeWindowDate()

    func setSelectedSavingsGoal(id: SavingsGoal.ID)

    func performTransfer() async throws

}
