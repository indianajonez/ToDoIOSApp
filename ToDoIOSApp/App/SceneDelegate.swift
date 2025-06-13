//
//  SceneDelegate.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Public Properties

    var window: UIWindow?

    // MARK: - UISceneDelegate Lifecycle

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let appearance = UINavigationBar.appearance()
        appearance.tintColor = AppColor.checkboxYellow
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: AppFont.title
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: AppFont.taskTitle
        ]

        let window = UIWindow(windowScene: windowScene)
        let navigationController = AppRouter().startApp() as! UINavigationController
        navigationController.navigationBar.prefersLargeTitles = true

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}


