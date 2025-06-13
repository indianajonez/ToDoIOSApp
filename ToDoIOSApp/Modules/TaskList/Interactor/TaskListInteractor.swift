//
//  TaskListInteractor.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation
import CoreData
import os

final class TaskListInteractor: TaskListInteractorInput {

    // MARK: - Public Properties

    weak var output: TaskListInteractorOutput?

    // MARK: - Private Properties

    private var currentFilter: String = ""
    private let coreDataManager: CoreDataManager
    private let isTestingSynchronously: Bool
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "ToDoIOSApp",
        category: "TaskListInteractor"
    )

    // MARK: - Initializer

    init(coreDataManager: CoreDataManager = .shared, isTestingSynchronously: Bool = false) {
        self.coreDataManager = coreDataManager
        self.isTestingSynchronously = isTestingSynchronously
    }

    // MARK: - Public Methods

    func fetchTasks() {
        perform {
            let context = self.coreDataManager.context
            let request = TaskEntity.fetchRequest()

            do {
                let count = try context.count(for: request)
                if count == 0 && !self.isTestingSynchronously {
                    try self.loadMockTasks()
                }
                self.applyCurrentFilter()
            } catch {
                self.logger.error("Ошибка загрузки: \(String(describing: error))")
                self.sendTasks([])
            }
        }
    }

    func addTask(_ task: TaskModel) {
        perform {
            self.saveTask(task)
            self.applyCurrentFilter()
        }
    }

    func deleteTask(_ task: TaskModel) {
        perform {
            let context = self.coreDataManager.context
            let request = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", task.id)

            do {
                if let entity = try context.fetch(request).first {
                    context.delete(entity)
                    self.coreDataManager.saveContext()
                }
                self.applyCurrentFilter()
            } catch {
                self.logger.error("Ошибка удаления: \(String(describing: error))")
            }
        }
    }

    func toggleTaskCompletion(taskID: Int64) {
        perform {
            let context = self.coreDataManager.context
            let request = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", taskID)

            do {
                if let entity = try context.fetch(request).first {
                    entity.completed.toggle()
                    self.coreDataManager.saveContext()
                }
                self.applyCurrentFilter()
            } catch {
                self.logger.error("Ошибка смены статуса: \(String(describing: error))")
            }
        }
    }

    func update(task: TaskModel) {
        perform {
            self.saveTask(task)
            self.applyCurrentFilter()
        }
    }

    func filterTasks(by searchText: String) {
        currentFilter = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        perform {
            self.applyCurrentFilter()
        }
    }

    // MARK: - Private Methods

    private func applyCurrentFilter() {
        let tasks = fetchFilteredTasks()
        sendTasks(tasks)
    }

    private func fetchFilteredTasks() -> [TaskModel] {
        let context = self.coreDataManager.context
        let request = TaskEntity.fetchRequest()

        do {
            let entities = try context.fetch(request)
            let models = entities.map { TaskModel(entity: $0) }

            guard !currentFilter.isEmpty else { return models }

            let normalizedFilter = currentFilter
                .lowercased()
                .replacingOccurrences(of: " ", with: "")

            return models.filter { task in
                let title = task.title.lowercased().replacingOccurrences(of: " ", with: "")
                let desc = task.taskDescription?.lowercased().replacingOccurrences(of: " ", with: "") ?? ""
                return title.contains(normalizedFilter) || desc.contains(normalizedFilter)
            }

        } catch {
            logger.error("Ошибка при фильтрации: \(String(describing: error))")
            return []
        }
    }

    private func sendTasks(_ tasks: [TaskModel]) {
        if isTestingSynchronously {
            output?.didFetchTasks(tasks)
        } else {
            DispatchQueue.main.async {
                self.output?.didFetchTasks(tasks)
            }
        }
    }

    private func saveTask(_ task: TaskModel) {
        let context = coreDataManager.context
        let request = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", task.id)

        do {
            let entity = try context.fetch(request).first ?? TaskEntity(context: context)
            entity.update(with: task)
            coreDataManager.saveContext()
        } catch {
            logger.error("Ошибка сохранения: \(String(describing: error))")
        }
    }

    private func loadMockTasks() throws {
        guard let data = MockTodoJSON.jsonString.data(using: .utf8) else { return }
        let decoded = try JSONDecoder().decode(TodoResponse.self, from: data)
        decoded.todos.map { TaskModel(dto: $0) }.forEach { saveTask($0) }
    }

    private func perform(_ block: @escaping () -> Void) {
        if isTestingSynchronously {
            block()
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                block()
            }
        }
    }
}

