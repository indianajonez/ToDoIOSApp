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
    private let coreDataManager: CoreDataManager
    private let isTestingSynchronously: Bool

    init(coreDataManager: CoreDataManager = .shared, isTestingSynchronously: Bool = false) {
        self.coreDataManager = coreDataManager
        self.isTestingSynchronously = isTestingSynchronously
    }

    func fetchTasks() {
        if isTestingSynchronously {
            applyCurrentFilter(sync: true)
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                self.applyCurrentFilter()
            }
        }
    }

    func addTask(_ task: TaskModel) {
        if isTestingSynchronously {
            saveTask(task)
            currentFilter = "" // 💡 Сброс фильтра
            applyCurrentFilter(sync: true)
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                self.saveTask(task)
                self.applyCurrentFilter()
            }
        }
    }

    func deleteTask(_ task: TaskModel) {
        DispatchQueue.global(qos: .userInitiated).async {
            let context = self.coreDataManager.context
            let request = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", task.id)

            do {
                if let entity = try context.fetch(request).first {
                    context.delete(entity)
                    self.coreDataManager.saveContext()
                }
                self.fetchTasks()
            } catch {
                print("Ошибка удаления: \(error)")
            }
        }
    }

    func toggleTaskCompletion(taskID: Int64) {
        DispatchQueue.global(qos: .userInitiated).async {
            let context = self.coreDataManager.context
            let request = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", taskID)

            do {
                if let entity = try context.fetch(request).first {
                    entity.completed.toggle()
                    self.coreDataManager.saveContext()
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

    private func applyCurrentFilter(sync: Bool = false) {
        let context = self.coreDataManager.context
        let request = TaskEntity.fetchRequest()

        if !currentFilter.isEmpty {
            request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
                NSPredicate(format: "title CONTAINS[cd] %@", currentFilter),
                NSPredicate(format: "taskDescription CONTAINS[cd] %@", currentFilter)
            ])
        }

        do {
            let entities = try context.fetch(request)
            let tasks = entities.map { TaskModel(entity: $0) }

            if sync {
                // ⚠️ Безопасная синхронная отправка
                if Thread.isMainThread {
                    self.output?.didFetchTasks(tasks)
                } else {
                    DispatchQueue.main.sync {
                        self.output?.didFetchTasks(tasks)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.output?.didFetchTasks(tasks)
                }
            }
        } catch {
            print("Ошибка при фильтрации: \(error)")

            if sync {
                if Thread.isMainThread {
                    self.output?.didFetchTasks([])
                } else {
                    DispatchQueue.main.sync {
                        self.output?.didFetchTasks([])
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.output?.didFetchTasks([])
                }
            }
        }
    }


    private func saveTask(_ task: TaskModel) {
        let context = self.coreDataManager.context
        let request = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", task.id)

        do {
            let entity = try context.fetch(request).first ?? TaskEntity(context: context)
            entity.update(with: task)
            self.coreDataManager.saveContext()
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }
}
