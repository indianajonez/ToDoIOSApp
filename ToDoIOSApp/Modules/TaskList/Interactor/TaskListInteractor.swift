//
//  TaskListInteractor.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation

final class TaskListInteractor: TaskListInteractorInput {
    weak var output: TaskListInteractorOutput?
    private var tasks: [TaskModel] = []

    func fetchTasks() {
        let mockTasks = [
            TaskModel(id: 1, title: "Пример задачи", description: "Описание", createdAt: Date(), isCompleted: false, isFromAPI: false),
            TaskModel(id: 2, title: "Уборка", description: "Генеральная уборка дома", createdAt: Date(), isCompleted: false, isFromAPI: false)
        ]
        self.tasks = mockTasks
        output?.didFetchTasks(tasks)
    }

    func toggleTaskCompletion(taskID: Int64) {
        if let index = tasks.firstIndex(where: { $0.id == taskID }) {
            tasks[index].isCompleted.toggle()
            output?.didFetchTasks(tasks)
        }
    }
    
    func filterTasks(by searchText: String) {
        let filtered = searchText.isEmpty
            ? tasks
            : tasks.filter { task in
                task.title.lowercased().contains(searchText.lowercased()) ||
                (task.description?.lowercased().contains(searchText.lowercased()) ?? false)
            }

        output?.didFetchTasks(filtered)
    }
}


