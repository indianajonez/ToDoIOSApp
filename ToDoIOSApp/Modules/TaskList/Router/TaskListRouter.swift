//
//  TaskListRouter.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import UIKit

final class TaskListRouter: TaskListRouterInput {
    weak var viewController: UIViewController?

    func navigateToTaskDetail(for task: TaskModel?) {
        if let presenter = (viewController as? TaskListViewController)?.presenter as? TaskListUpdater {
            let detailVC = TaskDetailModuleBuilder.build(task: task, updater: presenter)
            viewController?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    func showTaskActions(for task: TaskModel, from view: UIViewController) {
        // TODO
    }
}

