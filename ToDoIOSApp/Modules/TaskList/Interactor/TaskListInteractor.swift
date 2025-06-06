//
//  TaskListInteractor.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation
import CoreData

final class TaskListInteractor: TaskListInteractorInput {
    weak var output: TaskListInteractorOutput?
    private var currentFilter: String = ""

    func fetchTasks() {
        DispatchQueue.global(qos: .userInitiated).async {
            let context = CoreDataManager.shared.context
            let request = TaskEntity.fetchRequest()

            do {
                let entities = try context.fetch(request)

                if entities.isEmpty {
                    guard let data = MockTodoJSON.jsonString.data(using: .utf8) else { return }
                    let decoded = try JSONDecoder().decode(TodoResponse.self, from: data)
                    let mapped = decoded.todos.map { TaskModel(dto: $0) }
                    mapped.forEach { self.saveTask($0) }
                }

                self.applyCurrentFilter()
            } catch {
                print("Ошибка загрузки: \(error)")
                DispatchQueue.main.async {
                    self.output?.didFetchTasks([])
                }
            }
        }
    }

    func addTask(_ task: TaskModel) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.saveTask(task)
            self.fetchTasks()
        }
    }

    func deleteTask(_ task: TaskModel) {
        DispatchQueue.global(qos: .userInitiated).async {
            let context = CoreDataManager.shared.context
            let request = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", task.id)

            do {
                if let entity = try context.fetch(request).first {
                    context.delete(entity)
                    CoreDataManager.shared.saveContext()
                }
                self.fetchTasks()
            } catch {
                print("Ошибка удаления: \(error)")
            }
        }
    }

    func toggleTaskCompletion(taskID: Int64) {
        DispatchQueue.global(qos: .userInitiated).async {
            let context = CoreDataManager.shared.context
            let request = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", taskID)

            do {
                if let entity = try context.fetch(request).first {
                    entity.completed.toggle()
                    CoreDataManager.shared.saveContext()
                }
                self.fetchTasks()
            } catch {
                print("Ошибка смены статуса: \(error)")
            }
        }
    }

    func filterTasks(by searchText: String) {
        currentFilter = searchText
        applyCurrentFilter()
    }

    func update(task: TaskModel) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.saveTask(task)
            self.fetchTasks()
        }
    }

    private func applyCurrentFilter() {
        DispatchQueue.global(qos: .userInitiated).async {
            let context = CoreDataManager.shared.context
            let request = TaskEntity.fetchRequest()

            if !self.currentFilter.isEmpty {
                request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
                    NSPredicate(format: "title CONTAINS[cd] %@", self.currentFilter),
                    NSPredicate(format: "taskDescription CONTAINS[cd] %@", self.currentFilter)
                ])
            }

            do {
                let entities = try context.fetch(request)
                let tasks = entities.map { TaskModel(entity: $0) }

                DispatchQueue.main.async {
                    self.output?.didFetchTasks(tasks)
                }
            } catch {
                print("Ошибка при фильтрации: \(error)")
                DispatchQueue.main.async {
                    self.output?.didFetchTasks([])
                }
            }
        }
    }

    private func saveTask(_ task: TaskModel) {
        let context = CoreDataManager.shared.context
        let request = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", task.id)

        do {
            let entity = try context.fetch(request).first ?? TaskEntity(context: context)
            entity.update(with: task)
            CoreDataManager.shared.saveContext()
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }
}
