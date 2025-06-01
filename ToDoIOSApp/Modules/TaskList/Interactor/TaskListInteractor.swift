//
//  TaskListInteractor.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation

final class TaskListInteractor: TaskListInteractorInput {
    weak var output: TaskListInteractorOutput?

    func fetchTasks() {
        // TODO: CoreData или мок
        let mockTasks = [
            TaskModel(id: 1, title: "Пример задачи", description: "Описание", createdAt: Date(), isCompleted: false, isFromAPI: false)
        ]
        output?.didFetchTasks(mockTasks)
    }
}

