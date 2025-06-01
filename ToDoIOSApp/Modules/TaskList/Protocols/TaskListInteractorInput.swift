//
//  TaskListInteractorInput.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation

protocol TaskListInteractorInput: AnyObject {
    func fetchTasks()
    func toggleTaskCompletion(taskID: Int64)
    func filterTasks(by searchText: String)
    func addTask(_ task: TaskModel)
}
