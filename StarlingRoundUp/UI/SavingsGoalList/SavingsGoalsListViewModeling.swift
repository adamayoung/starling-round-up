//
//  SavingsGoalsListViewModeling.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

protocol SavingsGoalsListViewModeling {

    var accountID: Account.ID { get }
    var savingsGoals: [SavingsGoal] { get }

    func fetchSavingsGoals() async throws

}
