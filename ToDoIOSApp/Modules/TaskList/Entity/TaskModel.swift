//
//  TaskModel.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation

struct TaskModel {
    var id: Int64
    var title: String
    var description: String?
    var createdAt: Date
    var isCompleted: Bool
    var isFromAPI: Bool
}

