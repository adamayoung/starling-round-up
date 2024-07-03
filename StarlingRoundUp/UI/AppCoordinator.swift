//
//  AppCoordinator.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import UIKit

final class AppCoordinator: Coordinator {

    private let window: UIWindow
    private let factory: AppFactory
    private var navigationController: UINavigationController!

    init(window: UIWindow, factory: AppFactory) {
        self.window = window
        self.factory = factory
    }

    func start() {
        let accountListViewController = factory.accountListViewController()

        let navigationController = factory.mainNavigationController()
        navigationController.viewControllers = [accountListViewController]
        accountListViewController.delegate = self

        window.rootViewController = navigationController
        self.navigationController = navigationController
    }

}

extension AppCoordinator: AccountListViewControllerDelegate {

    func viewController(_: some AccountListViewControlling, didSelectAccount accountSummary: AccountSummary) {
        let accountDetailsViewController = factory.accountDetailsViewController(accountSummary: accountSummary)
        accountDetailsViewController.delegate = self
        navigationController.pushViewController(accountDetailsViewController, animated: true)
    }

}

extension AppCoordinator: AccountDetailsViewControllerDelegate {

    func viewController(
        _: some AccountDetailsViewControlling,
        didSelectSavingsGoalsForAccount accountID: Account.ID
    ) {
        let savingsGoalListViewController = factory.savingsGoalListViewController(accountID: accountID)
        navigationController.pushViewController(savingsGoalListViewController, animated: true)
    }

}
