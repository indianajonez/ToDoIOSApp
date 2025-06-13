//
//  TaskListModuleBuilder.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import UIKit

final class TaskListModuleBuilder {
    
    static func build() -> UIViewController {
        
        // MARK: - Create components
        let view = TaskListViewController()
        let interactor = TaskListInteractor()
        let presenter = TaskListPresenter()
        let router = TaskListRouter()

        // MARK: - Connect VIPER
        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view

        return view
    }
}
