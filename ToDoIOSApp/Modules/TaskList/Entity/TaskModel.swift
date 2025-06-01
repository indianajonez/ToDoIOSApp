//
//  TaskModel.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation

struct TaskModel {
    let id: Int64
    let title: String
    let description: String?
    let createdAt: Date
    let isCompleted: Bool
    let isFromAPI: Bool
}

