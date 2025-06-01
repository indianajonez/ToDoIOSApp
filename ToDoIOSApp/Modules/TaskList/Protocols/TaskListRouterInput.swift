//
//  TaskListRouterInput.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import UIKit

protocol TaskListRouterInput: AnyObject {
    func showTaskActions(for task: TaskModel, from view: UIViewController)
    func navigateToTaskDetail(for task: TaskModel?)
}
