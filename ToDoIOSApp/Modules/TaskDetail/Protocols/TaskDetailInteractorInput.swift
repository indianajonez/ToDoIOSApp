//
//  TaskDetailInteractorInput.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation

protocol TaskDetailInteractorInput: AnyObject {
    func saveTask(_ task: TaskModel)
}
