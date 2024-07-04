//
//  SavingsGoalListViewControllerDelegate.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

protocol SavingsGoalListViewControllerDelegate: AnyObject {

    func viewController(
        _ viewController: some SavingsGoalListViewControlling,
        wantsToCreateSavingsGoalForAccount accountID: Account.ID
    )

}
