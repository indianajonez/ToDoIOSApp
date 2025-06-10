//
//  TaskDetailInteractorOutput.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation

protocol TaskDetailInteractorOutput: AnyObject {
    func didSaveTask(_ task: TaskModel)
}
