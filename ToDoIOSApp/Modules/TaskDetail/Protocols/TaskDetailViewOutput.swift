//
//  TaskDetailViewOutput.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation

protocol TaskDetailViewOutput: AnyObject {
    func viewDidLoad()
    func didUpdateTask(title: String, description: String)
    var isNewTask: Bool { get }
}
