//
//  TaskListPresenter.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation

final class TaskListPresenter {

    // MARK: - Public Properties

    weak var view: TaskListViewInput?
    var interactor: TaskListInteractorInput?
    var router: TaskListRouterInput?
}

// MARK: - TaskListViewOutput

extension TaskListPresenter: TaskListViewOutput {
    func viewDidLoad() {
        interactor?.fetchTasks()
    }

    func didSelectTask(_ task: TaskModel) {
        router?.navigateToTaskDetail(for: task)
    }

    func didTapAddTask() {
        router?.navigateToTaskDetail(for: nil)
    }

    func didLongPressTask(_ task: TaskModel) {
        view?.showTaskActions(for: task)
    }

    func didToggleCompletion(for taskID: Int64) {
        interactor?.toggleTaskCompletion(taskID: taskID)
    }

    func filterTasks(by searchText: String) {
        interactor?.filterTasks(by: searchText)
    }

    func didRequestTaskDeletion(_ task: TaskModel) {
        interactor?.deleteTask(task)
    }
}

// MARK: - TaskListInteractorOutput

extension TaskListPresenter: TaskListInteractorOutput {
    func didFetchTasks(_ tasks: [TaskModel]) {
        view?.reloadTasks(tasks)
    }
}

// MARK: - TaskListUpdater

extension TaskListPresenter: TaskListUpdater {
    func add(task: TaskModel) {
        interactor?.addTask(task)
    }

    func update(task: TaskModel) {
        interactor?.update(task: task)
    }
}
