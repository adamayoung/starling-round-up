//
//  AddSavingsGoalViewModeling.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

protocol AddSavingsGoalViewModeling: AnyObject {

    var accountID: Account.ID { get }
    var currency: String { get }
    var savingsGoalName: String? { get set }
    var savingsGoalTarget: Int? { get set }
    var isFormValid: Bool { get }
    var onFormValidChanged: ((Bool) -> Void)? { get set }

    func save() async throws

}
