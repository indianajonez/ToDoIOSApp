//
//  TaskDetailViewInput.swift
//  ToDoIOSApp
//
//  Created by Ekaterina Saveleva on 01.06.2025.
//

import Foundation

protocol TaskDetailViewInput: AnyObject {
    func displayTask(title: String, description: String?, date: Date)
}


