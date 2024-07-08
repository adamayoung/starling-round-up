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

    func viewController(
        _ viewController: some AccountDetailsViewControlling,
        wantsToRoundUpForAccount accountID: Account.ID
    ) {
        let roundUpViewController = factory.roundUpViewController(accountID: accountID)
        roundUpViewController.delegate = self
        let roundUpNavigationController = UINavigationController(rootViewController: roundUpViewController)
        viewController.present(roundUpNavigationController, animated: true)
    }

}

extension AppCoordinator: SavingsGoalListViewControllerDelegate {

    func viewController(
        _ viewController: some SavingsGoalListViewControlling,
        wantsToCreateSavingsGoalForAccount accountID: Account.ID
    ) {
        let addSavingsGoalViewController = factory.addSavingsGoalViewController(accountID: accountID)
        addSavingsGoalViewController.delegate = self
        let addNavigationController = UINavigationController(rootViewController: addSavingsGoalViewController)
        viewController.present(addNavigationController, animated: true)
    }

}

extension AppCoordinator: AddSavingsGoalViewControllerDelegate {

    func viewControllerDidCreateSavingsGoal(_ viewController: some AddSavingsGoalViewControlling) {
        if let presentingViewController = viewController.presentingViewController {
            presentingViewController.dismiss(animated: true)
        }

        if let savingsGoalListViewController
            = navigationController.topViewController as? SavingsGoalListViewControlling {
            savingsGoalListViewController.refreshData()
        }

        if let presentedViewController = navigationController.presentedViewController as? UINavigationController,
           let roundUpViewController = presentedViewController.topViewController as? RoundUpViewControlling {
            roundUpViewController.refreshData()
        }
    }

    func viewControllerDidCancelCreatingsSavingsGoal(_ viewController: some AddSavingsGoalViewControlling) {
        if let presentingViewController = viewController.presentingViewController {
            presentingViewController.dismiss(animated: true)
        }
    }

}

extension AppCoordinator: RoundUpViewControllerDelegate {

    func viewController(
        _ viewController: some RoundUpViewControlling,
        didPerformTransferOfRoundUp _: RoundUpSummary
    ) {
        if let presentingViewController = viewController.presentingViewController {
            presentingViewController.dismiss(animated: true)
        }

        if let accountDetailsViewController
            = navigationController.topViewController as? AccountDetailsViewControlling {
            accountDetailsViewController.refreshData()
        }
    }

    func viewController(
        _ viewController: some RoundUpViewControlling,
        wantsToAddSavingsGoalToAccount accountID: Account.ID
    ) {
        let addSavingsGoalViewController = factory.addSavingsGoalViewController(accountID: accountID)
        addSavingsGoalViewController.delegate = self
        let addNavigationController = UINavigationController(rootViewController: addSavingsGoalViewController)
        viewController.present(addNavigationController, animated: true)
    }

    func viewControllerDidCancel(_ viewController: some RoundUpViewControlling) {
        if let presentingViewController = viewController.presentingViewController {
            presentingViewController.dismiss(animated: true)
        }
    }

}
