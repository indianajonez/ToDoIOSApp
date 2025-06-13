//
//  TaskDetailInteractor.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation

final class TaskDetailInteractor: TaskDetailInteractorInput {

    // MARK: - Public Properties

    weak var output: TaskDetailInteractorOutput?
    var task: TaskModel?

    // MARK: - Public Methods

    func didUpdateTask(title: String, description: String?) {
        guard var task = task else { return }
        task.title = title
        task.taskDescription = description
        self.task = task

        DispatchQueue.global(qos: .userInitiated).async {
            self.saveTask(task)
            DispatchQueue.main.async {
                self.output?.didSaveTask(task)
            }
        }
    }

    // MARK: - Private Methods

    func saveTask(_ task: TaskModel) {
        let context = CoreDataManager.shared.context
        let request = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %lld", task.id)

        do {
            let entity = try context.fetch(request).first ?? TaskEntity(context: context)
            entity.update(with: task)
            CoreDataManager.shared.saveContext()
        } catch {
            // Лучше использовать логгер вместо print
            NSLog("❌ Ошибка при сохранении задачи: \(error.localizedDescription)")
        }
    }
}

