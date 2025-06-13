//
//  AppRouter.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import UIKit

final class AppRouter {

    // MARK: - Public Methods

    func startApp() -> UIViewController {
        let taskListVC = TaskListModuleBuilder.build()
        let navigationController = UINavigationController(rootViewController: taskListVC)
        return navigationController
    }
}


