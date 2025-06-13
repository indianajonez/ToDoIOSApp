//
//  TaskDetailModuleBuilder.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import UIKit

// MARK: - TaskDetailModuleBuilder

enum TaskDetailModuleBuilder {
    
    static func build(task: TaskModel?, updater: TaskListUpdater) -> UIViewController {
        let view = TaskDetailViewController()
        let presenter = TaskDetailPresenter(task: task, listUpdater: updater)
        let interactor = TaskDetailInteractor()
        let router = TaskDetailRouter()

        // MARK: - VIPER Connections
        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        router.viewController = view

        return view
    }
}
