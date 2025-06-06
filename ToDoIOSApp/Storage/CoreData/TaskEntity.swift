//
//  TaskEntity.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 02.06.2025.
//

import Foundation
import CoreData

@objc(TaskEntity)
public class TaskEntity: NSManagedObject {}

extension TaskEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var completed: Bool
    @NSManaged public var createdAt: Date?
    @NSManaged public var isFromAPI: Bool
}

extension TaskEntity {
    func update(with model: TaskModel) {
        self.id = model.id
        self.title = model.title
        self.taskDescription = model.taskDescription
        self.completed = model.completed
        self.createdAt = model.createdAt
        self.isFromAPI = model.isFromAPI ?? false
    }
}
