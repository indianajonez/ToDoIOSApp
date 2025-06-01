//
//  TaskListRouter.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import UIKit

final class TaskListRouter: TaskListRouterInput {
    weak var viewController: UIViewController?

    func navigateToTaskDetail(with task: TaskModel) {
        // TODO: переход на экран редактирования задачи
    }

    func showTaskActions(for task: TaskModel, from view: UIViewController) {
        // TODO: UIContextMenu или UIAlertController
    }
}

