//
//  AddSavingsGoalViewControllerDelegate.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import Foundation

protocol AddSavingsGoalViewControllerDelegate: AnyObject {

    func viewControllerDidCreateSavingsGoal(_ viewController: some AddSavingsGoalViewControlling)

    func viewControllerDidCancelCreatingsSavingsGoal(_ viewController: some AddSavingsGoalViewControlling)

}
