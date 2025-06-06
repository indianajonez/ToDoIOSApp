//
//  TaskDetailPresenter.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation

final class TaskDetailPresenter: TaskDetailViewOutput {
    weak var view: TaskDetailViewInput?
    weak var listUpdater: TaskListUpdater?
    private var task: TaskModel?
    var interactor: TaskDetailInteractorInput?

    var isNewTask: Bool {
        task == nil
    }

    init(task: TaskModel?, listUpdater: TaskListUpdater?) {
        self.task = task
        self.listUpdater = listUpdater
    }

    func viewDidLoad() {
        view?.displayTask(
            title: task?.title ?? "",
            description: task?.taskDescription,
            date: task?.createdAt ?? Date()
        )
    }

    func didUpdateTask(title: String, description: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        if var existing = task {
            existing.title = trimmedTitle
            existing.taskDescription = description
            existing.isFromAPI = false
            interactor?.saveTask(existing)
            listUpdater?.update(task: existing)
        } else {
            let newTask = TaskModel(
                id: Int64(Date().timeIntervalSince1970),
                title: trimmedTitle,
                taskDescription: description,
                completed: false,
                createdAt: Date(),
                isFromAPI: false
            )
            interactor?.saveTask(newTask)
            listUpdater?.add(task: newTask)
        }
    }
}
