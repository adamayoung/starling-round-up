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

        // If app is under test, don't create the view hierarchy
        if isTesting {
            window.rootViewController = UIViewController()
            window.makeKeyAndVisible()
            return
        }

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

extension SceneDelegate {

    private var isTesting: Bool {
        let arguments = ProcessInfo.processInfo.arguments

        if arguments.contains("-testing") {
            return true
        }

        if arguments.contains("-snapshottesting") {
            return true
        }

        return false
    }

}
