//
//  TaskModel+Mapping.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 02.06.2025.
//

import Foundation
import CoreData

struct TaskModel: Identifiable, Equatable {
    // MARK: - Properties

    let id: Int64
    var title: String
    var taskDescription: String?
    var completed: Bool
    var createdAt: Date
    var isFromAPI: Bool?

    // MARK: - Init from manual data

    init(
        id: Int64 = Int64(Date().timeIntervalSince1970),
        title: String,
        taskDescription: String? = nil,
        completed: Bool = false,
        createdAt: Date = Date(),
        isFromAPI: Bool? = nil
    ) {
        self.id = id
        self.title = title
        self.taskDescription = taskDescription
        self.completed = completed
        self.createdAt = createdAt
        self.isFromAPI = isFromAPI
    }

    // MARK: - Init from CoreData entity

    init(entity: TaskEntity) {
        self.id = entity.id
        self.title = entity.title ?? ""
        self.taskDescription = entity.taskDescription
        self.completed = entity.completed
        self.createdAt = entity.createdAt ?? Date()
        self.isFromAPI = entity.isFromAPI
    }

    // MARK: - Init from API DTO

    init(dto: TodoDTO) {
        self.id = Int64(dto.id)
        self.title = "Задача № \(dto.id)"
        self.taskDescription = dto.todo
        self.completed = dto.completed
        self.createdAt = Date()
        self.isFromAPI = true
    }
}

