//
//  RoundUpViewControllerDelegate.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

protocol RoundUpViewControllerDelegate: AnyObject {

    func viewController(
        _ viewController: some RoundUpViewControlling,
        didPerformTransferOfRoundUp roundUpSummary: RoundUpSummary
    )

    func viewController(
        _ viewController: some RoundUpViewControlling,
        wantsToAddSavingsGoalToAccount accountID: Account.ID
    )

    func viewControllerDidCancel(_ viewController: some RoundUpViewControlling)

}
