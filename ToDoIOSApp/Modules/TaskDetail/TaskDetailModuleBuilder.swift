//
//  TaskDetailModuleBuilder.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import UIKit

enum TaskDetailModuleBuilder {
    static func build(task: TaskModel?, updater: TaskListUpdater) -> UIViewController {
        let view = TaskDetailViewController()
        let presenter = TaskDetailPresenter(task: task, listUpdater: updater)
        view.presenter = presenter
        presenter.view = view
        return view
    }
}

