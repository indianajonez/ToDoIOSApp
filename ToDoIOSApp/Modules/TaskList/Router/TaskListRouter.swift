//
//  TaskListRouter.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import UIKit

final class TaskListRouter: TaskListRouterInput {

    // MARK: - Public Properties

    weak var viewController: UIViewController?

    // MARK: - Public Methods

    func navigateToTaskDetail(for task: TaskModel?) {
        guard
            let presenter = (viewController as? TaskListViewController)?.presenter as? TaskListUpdater
        else { return }

        let detailVC = TaskDetailModuleBuilder.build(task: task, updater: presenter)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }

    func showTaskActions(for task: TaskModel, from view: UIViewController) {
        // Реализация не требуется — метод уже определён, но не используется
        // Оставляем пустым до внедрения контекстного меню или UIAlertController
    }
}

