//
//  TaskListViewInput.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation

protocol TaskListViewInput: AnyObject {
    func reloadTasks(_ tasks: [TaskModel])
}

