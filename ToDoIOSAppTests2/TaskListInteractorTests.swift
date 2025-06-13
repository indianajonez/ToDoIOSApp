//
//  TaskListInteractorTests.swift
//  ToDoIOSAppTests2
//
//  Created by Ekaterina Saveleva on 06.06.2025.
//

import XCTest
@testable import ToDoIOSApp

final class TaskListInteractorTests: XCTestCase {

    var sut: TaskListInteractor!
    var coreDataManager: CoreDataManager!

    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager.inMemory()
        sut = TaskListInteractor(coreDataManager: coreDataManager, isTestingSynchronously: true)
    }

    override func tearDown() {
        sut = nil
        coreDataManager = nil
        super.tearDown()
    }

    func testAddTask_savesTaskToCoreData() {
        let expectation = XCTestExpectation(description: "Task added and fetched")
        let testTitle = "Тестовая задача"
        let task = TaskModel(title: testTitle)

        let outputMock = OutputMock { tasks in
            print("✅ didFetchTasks вызван с задачами: \(tasks.map(\.title))")
            XCTAssertTrue(
                tasks.contains(where: { $0.title == testTitle }),
                "❌ Ожидалась задача с заголовком '\(testTitle)', но получили: \(tasks.map(\.title))"
            )
            expectation.fulfill()
        }

        sut.output = outputMock
        sut.addTask(task)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAddTask_savesToCoreDataStorage() {
        let task = TaskModel(title: "CoreData Check")
        sut.addTask(task)

        let request = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", task.title)

        let result = try? coreDataManager.context.fetch(request)
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?.first?.title, task.title)
    }
}

final class OutputMock: TaskListInteractorOutput {
    let onFetch: ([TaskModel]) -> Void

    init(onFetch: @escaping ([TaskModel]) -> Void) {
        self.onFetch = onFetch
    }

    func didFetchTasks(_ tasks: [TaskModel]) {
        onFetch(tasks)
    }
}
