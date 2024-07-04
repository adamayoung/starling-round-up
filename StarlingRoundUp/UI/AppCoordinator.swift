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
        savingsGoalListViewController.delegate = self
        navigationController.pushViewController(savingsGoalListViewController, animated: true)
    }

}

extension AppCoordinator: SavingsGoalListViewControllerDelegate {

    func viewController(
        _: some SavingsGoalListViewControlling,
        wantsToCreateSavingsGoalForAccount accountID: Account.ID
    ) {
        let addSavingsGoalViewController = factory.addSavingsGoalViewController(accountID: accountID)
        addSavingsGoalViewController.delegate = self
        let addNavigationController = UINavigationController(rootViewController: addSavingsGoalViewController)
        navigationController.present(addNavigationController, animated: true)
    }

}

extension AppCoordinator: AddSavingsGoalViewControllerDelegate {

    func viewControllerDidCreateSavingsGoal(_: some AddSavingsGoalViewControlling) {
        guard let savingsGoalListViewController =
            navigationController.topViewController as? SavingsGoalListViewControlling
        else {
            return
        }

        navigationController.dismiss(animated: true)
        savingsGoalListViewController.refreshData()
    }

    func viewControllerDidCancelCreatingsSavingsGoal(_: some AddSavingsGoalViewControlling) {
        guard navigationController.topViewController is SavingsGoalListViewControlling else {
            return
        }

        navigationController.dismiss(animated: true)
    }

}
