//
//  AccountDetailsViewControllerDelegate.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import Foundation

protocol AccountDetailsViewControllerDelegate: AnyObject {

    func viewController(
        _ viewController: some AccountDetailsViewControlling,
        didSelectSavingsGoalsForAccount accountID: Account.ID
    )

}
