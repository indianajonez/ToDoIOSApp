//
//  TaskDetailRouter.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import UIKit

final class TaskDetailRouter: TaskDetailRouterInput {

    // MARK: - Public Properties

    weak var viewController: UIViewController?

    // MARK: - Public Methods

    func close() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

