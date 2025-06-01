//
//  TaskListRouterInput.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import UIKit

protocol TaskListRouterInput: AnyObject {
    func navigateToTaskDetail(with task: TaskModel)
    func showTaskActions(for task: TaskModel, from view: UIViewController)
}
