//
//  AccountListViewControllerDelegate.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

protocol AccountListViewControllerDelegate: AnyObject {

    func viewController(
        _ viewController: some AccountListViewControlling,
        didSelectAccount accountSummary: AccountSummary
    )

}
