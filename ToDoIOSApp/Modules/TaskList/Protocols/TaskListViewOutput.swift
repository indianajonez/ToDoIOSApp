//
//  TaskListViewOutput.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation

protocol TaskListViewOutput: AnyObject {
    func viewDidLoad()
    func didSelectTask(_ task: TaskModel)
    func didTapAddTask()
    func didLongPressTask(_ task: TaskModel)
}
