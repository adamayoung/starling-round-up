//
//  SceneDelegate.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var appCoordinator: (any Coordinator)?
    private let factory = AppFactory()

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else {
            return
        }

        let window = UIWindow(windowScene: scene)
        let appCoordinator = AppCoordinator(window: window, factory: factory)
        appCoordinator.start()
        window.makeKeyAndVisible()

        self.window = window
        self.appCoordinator = appCoordinator
    }

    func sceneDidDisconnect(_: UIScene) {}

    func sceneDidBecomeActive(_: UIScene) {}

    func sceneWillResignActive(_: UIScene) {}

    func sceneWillEnterForeground(_: UIScene) {}

    func sceneDidEnterBackground(_: UIScene) {}

}
