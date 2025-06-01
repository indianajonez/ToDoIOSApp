//
//  TaskListUpdater.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation

protocol TaskListUpdater: AnyObject {
    func add(task: TaskModel)
    func update(task: TaskModel)
}

