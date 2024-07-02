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

        window.rootViewController = navigationController
        self.navigationController = navigationController
    }

}
