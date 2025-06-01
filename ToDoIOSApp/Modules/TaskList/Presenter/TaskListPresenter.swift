//
//  TaskListPresenter.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation

final class TaskListPresenter {
    weak var view: TaskListViewInput?
    var interactor: TaskListInteractorInput?
    var router: TaskListRouterInput?
}

extension TaskListPresenter: TaskListViewOutput {
    func viewDidLoad() {
        interactor?.fetchTasks()
    }

    func didSelectTask(_ task: TaskModel) {
        router?.navigateToTaskDetail(with: task)
    }

    func didTapAddTask() {
        // TBD
    }

    func didLongPressTask(_ task: TaskModel) {
        // TBD
    }
    
    func didToggleCompletion(for taskID: Int64) {
        interactor?.toggleTaskCompletion(taskID: taskID)
    }
    
    func filterTasks(by searchText: String) {
        interactor?.filterTasks(by: searchText)
    }


}

extension TaskListPresenter: TaskListInteractorOutput {
    func didFetchTasks(_ tasks: [TaskModel]) {
        view?.reloadTasks(tasks)
    }
}
