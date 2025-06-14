//
//  TaskListInteractorOutput.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation

protocol TaskListInteractorOutput: AnyObject {
    func didFetchTasks(_ tasks: [TaskModel])
}
